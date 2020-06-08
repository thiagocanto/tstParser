class IntegrationProcessesController < ApplicationController
    skip_before_action :verify_authenticity_token
    def parse
        errors = {}
        integration_process = nil
        headers = {
            "content-Type" => 'application/json',
            "X-Sent" => DateTime.now.strftime("%Hh%I - %d/%m/%y")
        }

        data = {
            externalCode: params[:id],
            storeId: params[:store_id],
            subTotal: params[:total_amount],
            deliveryFee: params[:total_shipping],
            total_shipping: params[:total_shipping],
            total: params[:total_amount_with_shipping],
            country: params.dig(:shipping, :receiver_address, :country, :id),
            state: params.dig(:shipping, :receiver_address, :state, :name),
            city: params.dig(:shipping, :receiver_address, :city, :name),
            district: params.dig(:shipping, :receiver_address, :neighborhood, :name),
            street: params.dig(:shipping, :receiver_address, :street_name),
            complement: params.dig(:shipping, :receiver_address, :comment),
            latitude: params.dig(:shipping, :receiver_address, :latitude),
            longitude: params.dig(:shipping, :receiver_address, :longitude),
            dtOrderCreate: DateTime.now,
            postalCode: params.dig(:shipping, :receiver_address, :zip_code),
            number: "0",
            customer: {
                externalCode: params.dig(:buyer, :id),
                name: params.dig(:buyer, :nickname),
                email: params.dig(:buyer, :email),
                contact: "#{params.dig(:buyer, :phone, :area_code)}#{params.dig(:buyer, :phone, :number)}"
            },
            items: params[:order_items].collect do |item|
                {
                    externalCode: item.dig(:item, :id),
                    name: item.dig(:item, :title),
                    price: item[:unit_price],
                    quantity: item[:quantity],
                    total: item[:full_unit_price],
                    subItems: []
                }
            end,
            payments: params[:payments].collect do |payment|
                {
                    type: payment[:payment_type].upcase,
                    value: payment[:total_paid_amount]
                }
            end
        }

        uri = URI("https://delivery-center-recruitment-ap.herokuapp.com/")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, headers)
        request.body = data.to_json

        response = http.request(request)
        case response
            when Net::HTTPSuccess then
                ActiveRecord::Base.transaction do
                    store = Store.find_or_create_by({
                        id: params[:store_id]
                    }).save

                    customer_data = {}
                    data[:customer].each {|key,value| customer_data[key.to_s.underscore.to_sym] = value}
                    customer = Customer.find_or_create_by(customer_data)
                    errors[:customer] = customer.errors unless customer.save

                    process_data = {}
                    data.each do |key,value|
                        next if [:customer, :items, :payments, :total_shipping].include? key
                        process_data[key.to_s.underscore.to_sym] = value
                    end
                    integration_process = IntegrationProcess.new(process_data)
                    integration_process.customer = customer
                    errors[:process] = integration_process.errors unless integration_process.save

                    items = []
                    data[:items].each do |item|
                        errors[:items] = [] if errors[:items].nil?
                        item_data = {}
                        item.each do |key, value|
                            next if [:subItems].include? key
                            item_data[key.to_s.underscore.to_sym] = value
                        end
                        item = Item.new(item_data)
                        item.integration_process = integration_process
                        errors[:items] << item.errors unless item.save
                    end

                    payments = []
                    data[:payments].each do |payment|
                        errors[:payments] = [] if errors[:payments].nil?
                        payment_data = {}
                        payment.each do |key, value|
                            if key == :type
                                payment_data[:payment_type] = value
                            else
                                payment_data[key.to_s.underscore.to_sym] = value
                            end
                        end
                        payment = Payment.new(payment_data)
                        payment.integration_process = integration_process
                        errors[:payments] << payment.errors unless payment.save
                    end

                    raise ActiveRecord::Rollback unless errors.empty?
                end
            else
                errors[:validation] = response.body
        end

        return render json: { parsedData: data, errors: errors} unless errors.empty?
        render json: { data: integration_process, parsedData: data, request_response: response.body }
    end

    private
    def integration_process_params data = nil
        params.permit(:id, :store_id, :total_amount, :total_shipping, :total_amount_with_shipping, :shipping)
    end
end
