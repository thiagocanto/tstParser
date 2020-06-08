module OrdersHelper
    def self.build_payload(info)
        {
            externalCode: info[:id],
            storeId: info[:store_id],
            subTotal: info[:total_amount],
            deliveryFee: info[:total_shipping],
            total_shipping: info[:total_shipping],
            total: info[:total_amount_with_shipping],
            country: info.dig(:shipping, :receiver_address, :country, :id),
            state: info.dig(:shipping, :receiver_address, :state, :name),
            city: info.dig(:shipping, :receiver_address, :city, :name),
            district: info.dig(:shipping, :receiver_address, :neighborhood, :name),
            street: info.dig(:shipping, :receiver_address, :street_name),
            complement: info.dig(:shipping, :receiver_address, :comment),
            latitude: info.dig(:shipping, :receiver_address, :latitude),
            longitude: info.dig(:shipping, :receiver_address, :longitude),
            dtOrderCreate: DateTime.now,
            postalCode: info.dig(:shipping, :receiver_address, :zip_code),
            number: info.dig(:shipping, :receiver_address, :street_number),
            customer: {
                externalCode: info.dig(:buyer, :id),
                name: info.dig(:buyer, :nickname),
                email: info.dig(:buyer, :email),
                contact: "#{info.dig(:buyer, :phone, :area_code)}#{info.dig(:buyer, :phone, :number)}"
            },
            items: info[:order_items].collect do |item|
                {
                    externalCode: item.dig(:item, :id),
                    name: item.dig(:item, :title),
                    price: item[:unit_price],
                    quantity: item[:quantity],
                    total: item[:full_unit_price],
                    subItems: []
                }
            end,
            payments: info[:payments].collect do |payment|
                {
                    type: payment[:payment_type].upcase,
                    value: payment[:total_paid_amount]
                }
            end
        }
    end

    def self.validate(url, data)
        headers = {
            "content-Type" => 'application/json',
            "X-Sent" => DateTime.now.strftime("%Hh%I - %d/%m/%y")
        }
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, headers)
        request.body = data.to_json

        http.request(request)
    end

    def self.save_order(response, data)
        order = nil
        errors = {}

        case response
        when Net::HTTPSuccess then
            ActiveRecord::Base.transaction do
                store = Store.find_or_create_by(id: data[:storeId]).save

                customer_data = parse_info(data[:customer])
                customer = Customer.find_or_create_by(customer_data)
                errors[:customer] = customer.errors unless customer.save

                order_data = parse_info(data, [:customer, :items, :payments, :total_shipping])
                order = Order.new(order_data)
                order.customer = customer
                errors[:order] = order.errors unless order.save

                if order
                    data[:items].each do |item|
                        item_data = parse_info(item, [:subItems])
                        item = Item.new(item_data)
                        item.order = order
                        unless item.save
                            errors[:items] = [] if errors[:items].nil?
                            errors[:items] << item.errors
                        end
                    end

                    data[:payments].each do |payment|
                        payment_data = parse_info(payment, [], {type: :payment_type})
                        payment = Payment.new(payment_data)
                        payment.order = order
                        unless payment.save
                            errors[:payments] = [] if errors[:payments].nil?
                            errors[:payments] << payment.errors
                        end
                    end
                end

                raise ActiveRecord::Rollback unless errors.empty?
            end
        else
            errors[:validation] = response.body
        end

        {
            data: order,
            errors: errors
        }
    end

    # Parse info and exclude fields
    def self.parse_info(root_info, excluded_fields = [], replace_fields = {})
        parsed_data = {}
        root_info.each do |key,value|
            next if excluded_fields.include? key
            if replace_fields.has_key? key
                parsed_data[replace_fields[key]] = value
            else
                parsed_data[key.to_s.underscore.to_sym] = value
            end
        end

        parsed_data
    end
end
