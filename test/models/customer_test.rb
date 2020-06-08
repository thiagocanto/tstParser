require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "should create customer successfully" do
    customer = Customer.new({
      external_code: "9123993",
      store_id: 282,
      
    })

    assert customer.save, customer.errors
  end
end
