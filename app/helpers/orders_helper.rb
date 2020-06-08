module OrdersHelper
    def self.build_payload(info)
        {
            externalCode: info[:id],
            storeId: info[:store_id],
            subTotal: info[:total_amount],
            deliveryFee: info[:total_shipping],
            total_shipping: info[:total_shipping],
            total: info[:total_amount_with_shipping],
            country: info.dig(:shipping, :receiver_address, :country, :id),
            state: info.dig(:shipping, :receiver_address, :state, :name),
            city: info.dig(:shipping, :receiver_address, :city, :name),
            district: info.dig(:shipping, :receiver_address, :neighborhood, :name),
            street: info.dig(:shipping, :receiver_address, :street_name),
            complement: info.dig(:shipping, :receiver_address, :comment),
            latitude: info.dig(:shipping, :receiver_address, :latitude),
            longitude: info.dig(:shipping, :receiver_address, :longitude),
            dtOrderCreate: DateTime.now,
            postalCode: info.dig(:shipping, :receiver_address, :zip_code),
            number: "0",
            customer: {
                externalCode: info.dig(:buyer, :id),
                name: info.dig(:buyer, :nickname),
                email: info.dig(:buyer, :email),
                contact: "#{info.dig(:buyer, :phone, :area_code)}#{info.dig(:buyer, :phone, :number)}"
            },
            items: info[:order_items].collect do |item|
                {
                    externalCode: item.dig(:item, :id),
                    name: item.dig(:item, :title),
                    price: item[:unit_price],
                    quantity: item[:quantity],
                    total: item[:full_unit_price],
                    subItems: []
                }
            end,
            payments: info[:payments].collect do |payment|
                {
                    type: payment[:payment_type].upcase,
                    value: payment[:total_paid_amount]
                }
            end
        }
    end
end
