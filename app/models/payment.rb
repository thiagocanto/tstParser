class Payment < ApplicationRecord
    validates :payment_type, presence: true
    validates :value, presence: true
end
