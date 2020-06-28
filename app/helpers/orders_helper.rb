module OrdersHelper
    API_ENDPOINT = "https://delivery-center-recruitment-ap.herokuapp.com/"

    def self.build_payload(info)
        items = info[:order_items] || []
        payments = info[:payments] || []

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
            items: items.collect do |item|
                {
                    externalCode: item.dig(:item, :id),
                    name: item.dig(:item, :title),
                    price: item[:unit_price],
                    quantity: item[:quantity],
                    total: item[:full_unit_price],
                    subItems: []
                }
            end,
            payments: payments.collect do |payment|
                {
                    type: payment[:payment_type].upcase,
                    value: payment[:total_paid_amount]
                }
            end
        }
    end

    # Parse info and exclude fields
    def self.parse_info_to_snakecase(root_info, excluded_fields = [], replace_fields = {})
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

    # Parse info and exclude fields
    def self.parse_info_to_camelcase(root_info, excluded_fields = [], replace_fields = {})
        parsed_data = {}
        JSON.parse(root_info).each do |key,value|
            next if excluded_fields.include? key
            if replace_fields.has_key? key
                parsed_data[replace_fields[key]] = value
            else
                parsed_data[key.to_s.camelize(:lower).to_sym] = value
            end
        end

        parsed_data
    end

    def self.do_external_validation(data)
        headers = {
            "content-Type" => 'application/json',
            "X-Sent" => DateTime.now.strftime("%Hh%I - %d/%m/%y")
        }
        uri = URI(API_ENDPOINT)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, headers)
        request.body = data.to_json

        http.request(request)
    end
end
