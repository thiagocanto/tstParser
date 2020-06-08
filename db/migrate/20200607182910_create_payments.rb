class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :order, column: :order_id, null: true
      t.string :payment_type
      t.float :value

      t.timestamps
    end
  end
end
