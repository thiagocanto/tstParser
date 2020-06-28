class Payment < ApplicationRecord
    validates :payment_type, presence: true
    validates :value, presence: true

    belongs_to :order

    def self.add_to_order(data, order)
        payment = Payment.new(data)
        payment.order = order

        unless payment.save
            Rails.logger.debug("Payment couldn't be created:")
            Rails.logger.debug(payment.errors.full_messages)
            raise ActiveRecord::Rollback
        end
        payment
    end
end
