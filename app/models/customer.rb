class Customer < ApplicationRecord
    validates :external_code, presence: true
    validates :name, presence: true
    validates :email, presence: true
    validates :contact, presence: true
end
