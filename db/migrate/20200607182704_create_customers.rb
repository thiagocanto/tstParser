class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :external_code
      t.string :name
      t.string :email
      t.string :contact

      t.timestamps
    end

    add_column :integration_processes, :customer_id, :integer, after: :store_id
    add_foreign_key :integration_processes, :customers, on_delete: :cascade
  end
end
