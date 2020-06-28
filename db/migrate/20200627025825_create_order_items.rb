class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :item
      t.integer :quantity

      t.timestamps
    end
  end
end
