class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token
    def parse
        errors = {}
        order = nil
        headers = {
            "content-Type" => 'application/json',
            "X-Sent" => DateTime.now.strftime("%Hh%I - %d/%m/%y")
        }

        data = OrdersHelper::build_payload params

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
                    order = IntegrationProcess.new(process_data)
                    order.customer = customer
                    errors[:order] = order.errors unless order.save

                    items = []
                    data[:items].each do |item|
                        item_data = {}
                        item.each do |key, value|
                            next if [:subItems].include? key
                            item_data[key.to_s.underscore.to_sym] = value
                        end
                        item = Item.new(item_data)
                        item.order = order
                        unless item.save
                            errors[:items] = [] if errors[:items].nil?
                            errors[:items] << item.errors
                        end
                    end

                    payments = []
                    data[:payments].each do |payment|
                        payment_data = {}
                        payment.each do |key, value|
                            if key == :type
                                payment_data[:payment_type] = value
                            else
                                payment_data[key.to_s.underscore.to_sym] = value
                            end
                        end
                        payment = Payment.new(payment_data)
                        payment.order = order
                        unless payment.save
                            errors[:payments] = [] if errors[:payments].nil?
                            errors[:payments] << payment.errors
                        end
                    end

                    raise ActiveRecord::Rollback unless errors.empty?
                end
            else
                errors[:validation] = response.body
        end

        return render json: { parsedData: data, errors: errors} unless errors.empty?
        render json: { data: order, parsedData: data, request_response: response.body }
    end

    private
    def order_params
        params.permit(:id, :store_id, :total_amount, :total_shipping, :total_amount_with_shipping, :shipping)
    end
end
