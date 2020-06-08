class OrderSerializer < ActiveModel::Serializer
    attributes :externalCode, :storeId, :subTotal, :deliveryFee, :total, :country, :state, :city, :district, :street, :complement, :latitude, :longitude, :dtOrderCreate, :postalCode, :number

    attributes :customer, :items, :payments

    def externalCode
        object.external_code
    end
    def storeId
        object.store_id
    end
    def subTotal
        object.sub_total
    end
    def deliveryFee
        object.delivery_fee
    end
    def dtOrderCreate
        object.dt_order_create
    end
    def postalCode
        object.postal_code
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
        object.payments.collect do |payment|
            {
                type: payment.payment_type,
                value: payment.value
            }
        end
    end
end