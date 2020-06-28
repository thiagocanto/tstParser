class OrderSerializer < ActiveModel::Serializer
    attributes :externalCode, :storeId, :subTotal, :deliveryFee, :total, :country, :state, :city, :district, :street, :complement, :latitude, :longitude, :dtOrderCreate, :postalCode, :number

    attributes :items
    belongs_to :customer
    has_many :payments

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

    def items
        object.items.collect do |item|
            quantity = item.order_items.where(order_id: object.id).first.quantity

            {
                externalCode: item.external_code,
                name: item.name,
                price: item.price,
                quantity: quantity,
                total: item.price * quantity,
                subItems: []
            }
        end
    end
end