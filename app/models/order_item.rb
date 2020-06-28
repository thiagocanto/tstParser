class OrderItem < ApplicationRecord
    validates :quantity, presence: true
    
    belongs_to :order
    belongs_to :item
end
