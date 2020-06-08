class Order < ApplicationRecord
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
    has_many :items
    has_many :payments
end
