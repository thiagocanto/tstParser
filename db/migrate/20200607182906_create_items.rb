class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.references :integration_process, column: :integration_process_id, null: true
      t.references :items, column: :parent_idem_id
      t.string :external_code
      t.string :name
      t.float :price
      t.integer :quantity
      t.float :total

      t.timestamps
    end
  end
end
