require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  setup do
    @customer = Customer.new
  end

  test "should create customer successfully" do
    assert_not @customer.save, "Saved with empty fields"

    @customer.external_code = "9123993"
    @customer.name = "Dummy customer"
    @customer.email = "dummy@email.com"
    @customer.contact = "41999999999"
    assert @customer.save, @customer.errors.full_messages
  end
end
