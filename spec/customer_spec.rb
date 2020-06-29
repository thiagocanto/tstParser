require 'rails_helper'

describe Customer do
    it "shouldn't save without external_code" do
        customer = Customer.new(external_code: nil)
        customer.valid?
        expect(customer.errors[:external_code]).to include("can't be blank")
    end
    it "shouldn't save without name" do
        customer = Customer.new(name: nil)
        customer.valid?
        expect(customer.errors[:name]).to include("can't be blank")
    end
    it "shouldn't save without email" do
        customer = Customer.new(email: nil)
        customer.valid?
        expect(customer.errors[:email]).to include("can't be blank")
    end
    it "shouldn't save without contact" do
        customer = Customer.new(contact: nil)
        customer.valid?
        expect(customer.errors[:contact]).to include("can't be blank")
    end
end
