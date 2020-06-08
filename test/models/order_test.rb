require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = Order.new
    @customer = customers :one
  end

  test "should create order" do
    assert_not @order.save, "Saved without fields set"

    @order.external_code = "123456789"
    @order.store_id = 282
    @order.sub_total = 15
    @order.delivery_fee = 5
    @order.total = 20
    @order.country = "BR"
    @order.state = "PR"
    @order.city = "Curitiba"
    @order.district = "Bairro teste"
    @order.street = "Rua teste"
    @order.complement = "Apto 10"
    @order.latitude = -23.529037
    @order.longitude = -46.742689
    @order.dt_order_create = Date.current
    @order.postal_code = "29333000"
    @order.number = "50"
    @order.customer = @customer

    assert @order.save, @order.errors.full_messages
  end
end
