class Payment < ApplicationRecord
    validates :payment_type, presence: true
    validates :value, presence: true

    belongs_to :integration_process
end
