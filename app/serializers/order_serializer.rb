class OrderSerializer < ActiveModel::Serializer
    attributes :externalCode, :storeId

    attributes :customer, :items, :payments

    def externalCode
        object.external_code
    end
    def storeId
        object.store_id
    end

    def customer
        {
            externalCode: object.customer.external_code,
            name: object.customer.name,
            email: object.customer.email,
            contact: object.customer.contact
        }
    end

    def items
        object.items.collect do |item|
            {
                externalCode: item.external_code,
                name: item.name,
                price: item.price,
                quantity: item.quantity,
                total: item.total,
                subItems: []
            }
        end
    end

    def payments
        Rails.logger.info(object.payments.inspect)
        return [] if object.payments.nil?
        object.payments.collect do |payment|
            {
                type: payment.payment_type,
                value: payment.value
            }
        end
    end
end