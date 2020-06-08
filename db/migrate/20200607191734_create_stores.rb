class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name

      t.timestamps
    end

    add_foreign_key :orders, :stores, on_delete: :cascade
  end
end
