class Item < ApplicationRecord
    validates :external_code, presence: true
    validates :name, presence: true
    validates :price, presence: true

    has_many :order_items
    has_many :orders, through: :order_items
    has_many :items, as: :sub_items

    def self.add_to_order(data, order)
        quantity = data.extract!(:quantity)[:quantity] || 1

        item = find_by(external_code: data[:external_code])
        item = new(data) if item.nil?

        unless item.save
            Rails.logger.debug("Item couldn't be created:")
            Rails.logger.debug(item.errors.full_messages)
            raise ActiveRecord::Rollback
        end
        OrderItem.create({
            item: item,
            order: order,
            quantity: quantity
        })
    end
end
