require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "should create item" do
    order = orders :one
    item = Item.new({
      external_code: "IT12738173123",
      name: "Item de teste",
      quantity: 2,
      price: 5,
      total: 10,
      order: order
    })

    assert item.save, item.errors.full_messages
  end
end
