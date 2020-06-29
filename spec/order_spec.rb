require 'rails_helper'

describe Order do
    before(:each) do
        @order_data = {
            external_code: "000000002",
            store_id: 282,
            sub_total: 15,
            delivery_fee: 5,
            total: 20,
            country: "BR",
            state: "PR",
            city: "Curitiba",
            district: "Bacacheri",
            street: "Rua teste",
            complement: "Apto 1",
            latitude: -23.629037,
            longitude: -46.712689,
            dt_order_create: Date.current - 1.day,
            postal_code: "93020020",
            number: "34"
        }
    end
    it "shouldn't save with missing fields" do
        order = Order.new

        expect(order).not_to be_valid
    end
    it "shouldn't save without customer" do
        order = Order.new
        order.valid?

        expect(order.errors[:customer_data]).to include("can't be blank")
    end
    it "shouldn't save without items" do
        order = Order.new(@order_data)
        order.customer_data = {external_code: "00001"}
        order.save

        expect(order).not_to be_valid
        expect(order.errors[:items_data]).to include("can't be blank")
    end
    it "shouldn't save without payments" do
        order = Order.new(@order_data)
        order.customer_data = {external_code: "00001"}
        order.save

        expect(order).not_to be_valid
        expect(order.errors[:payments_data]).to include("can't be blank")
    end
end
