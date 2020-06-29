require 'rails_helper'

describe Item do
    it "shouldn't save without external_code" do
        item = Item.new
        item.valid?

        expect(item.errors[:external_code]).to include("can't be blank")
    end
    it "shouldn't save without name" do
        item = Item.new
        item.valid?

        expect(item.errors[:name]).to include("can't be blank")
    end
    it "shouldn't save without price" do
        item = Item.new
        item.valid?

        expect(item.errors[:price]).to include("can't be blank")
    end
end