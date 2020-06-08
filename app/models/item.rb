class Item < ApplicationRecord
    validates :external_code, presence: true
    validates :name, presence: true
    validates :price, presence: true
    validates :quantity, presence: true
    validates :total, presence: true

    belongs_to :order
    has_many :items, as: :sub_items
end
