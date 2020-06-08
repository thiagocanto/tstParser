class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :payment_type
      t.float :value

      t.timestamps
    end
  end
end
