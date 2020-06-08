class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token
    def index
        orders = Order.preload(:customer, :items, :payments).all

        render json: orders
    end

    def create
        data = OrdersHelper.build_payload params
        response = OrdersHelper.validate "https://delivery-center-recruitment-ap.herokuapp.com/", data
        saved_data = OrdersHelper.save_order response, data

        return render json: { parsedData: data, errors: saved_data[:errors]} unless saved_data[:errors].empty?
        render json: saved_data
    end

    private
    def order_params
        params.permit(:id, :store_id, :total_amount, :total_shipping, :total_amount_with_shipping, :shipping)
    end
end
