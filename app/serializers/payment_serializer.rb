class PaymentSerializer < ActiveModel::Serializer
    attributes :type, :value

    def type
        object.payment_type
    end
end
