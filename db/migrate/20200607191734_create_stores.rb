class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name

      t.timestamps
    end

    add_foreign_key :integration_processes, :stores, on_delete: :cascade
  end
end
