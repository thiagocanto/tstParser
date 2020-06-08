require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "should create item" do
    item = Item.new({
      external_code: "IT12738173123",
      name: "Item de teste",
      quantity: 2,
      unit_price: 5,
      total: 10
    })

    assert item.save, item.errors
  end
end
