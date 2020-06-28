class Customer < ApplicationRecord
    validates :external_code, presence: true
    validates :name, presence: true
    validates :email, presence: true
    validates :contact, presence: true, format: { with: /\d{11}/ }

    has_many :orders, dependent: :delete_all
end
