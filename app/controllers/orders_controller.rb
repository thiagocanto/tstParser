class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        orders = Order.preload(:customer, :order_items, :items, :payments).all

        render json: orders
    end

    def create
        parsed_data = OrdersHelper.build_payload(params)
        response = OrdersHelper.do_external_validation(parsed_data)

        if response == Net::HTTPSuccess
            Rails.logger.debug("A validação externa falhou. Resposta:\n #{response.body}")
            return render json: { data: parsed_data, response: response.body }
        end

        order = Order.new(OrdersHelper.parse_info_to_snakecase(parsed_data, [:customer, :items, :payments, :total_shipping]))
        order.customer_data = OrdersHelper.parse_info_to_snakecase(parsed_data[:customer])
        order.items_data = parsed_data[:items].collect { |item_data| OrdersHelper.parse_info_to_snakecase(item_data, [:subItems]) }
        order.payments_data = parsed_data[:payments].collect { |payment_data| OrdersHelper.parse_info_to_snakecase(payment_data, [], {type: :payment_type}) }

        return render json: { parsedData: parsed_data, errors: order.errors } unless order.save
        render json: order
    end
end
