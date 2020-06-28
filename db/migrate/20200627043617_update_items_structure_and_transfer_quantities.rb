class UpdateItemsStructureAndTransferQuantities < ActiveRecord::Migration[6.0]
  def change
    Rails.logger.debug(OrderItem.inspect)
    Item.find_each do |item|
      OrderItem.create({
        order_id: item.order_id,
        item_id: item.id,
        quantity: item.quantity
      })
    end

    remove_column :items, :order_id
    remove_column :items, :quantity
  end
end
