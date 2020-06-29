class Order < ApplicationRecord
    attr_accessor :customer_data, :payments_data, :items_data

    validates :external_code, presence: true
    validates :store_id, presence: true
    validates :sub_total, presence: true
    validates :delivery_fee, presence: true
    validates :total, presence: true
    validates :country, presence: true
    validates :state, presence: true
    validates :city, presence: true
    validates :district, presence: true
    validates :street, presence: true
    validates :complement, presence: true
    validates :latitude, presence: true
    validates :longitude, presence: true
    validates :dt_order_create, presence: true
    validates :postal_code, presence: true
    validates :number, presence: true

    belongs_to :customer
    has_many :order_items
    has_many :items, through: :order_items
    has_many :payments

    before_validation :set_customer
    before_validation :check_order
    after_save :add_items
    after_save :add_payments

    def set_customer
        unless customer_data.present?
            errors.add(:customer_data, "can't be blank")
            return false
        end
        customer = Customer.find_by(external_code: customer_data[:external_code])
        customer = Customer.create(customer_data) if customer.nil?
        return errors.add(:customer, customer.errors) if customer.errors.present?

        self.customer = customer
    end

    def check_order
        unless items_data.present? && payments_data.present?
            errors.add(:items_data, "can't be blank")
            errors.add(:payments_data, "can't be blank")
            return false
        end
    end

    def add_items
        unless items_data.present?
            errors.add(:items_data, "can't be blank")
            return false
        end
        items_data.each {|item_data| order_items << Item.add_to_order(item_data, self)}
    end

    def add_payments
        unless payments_data.present?
            errors.add(:payments_data, "can't be blank")
            return false
        end
        payments_data.each {|payment_data| payments << Payment.add_to_order(payment_data, self)}
    end
end
