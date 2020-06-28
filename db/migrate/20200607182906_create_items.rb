class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.references :order, null: true, foreign_key: true
      t.references :item, null: true
      t.string :external_code
      t.string :name
      t.float :price
      t.integer :quantity
      t.float :total

      t.timestamps
    end
  end
end
