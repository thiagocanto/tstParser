class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :external_code
      t.string :name
      t.string :email
      t.string :contact

      t.timestamps
    end

    add_column :orders, :customer_id, :integer, after: :store_id
    add_foreign_key :orders, :customers, on_delete: :cascade
  end
end
