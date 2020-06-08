class CreateIntegrationProcesses < ActiveRecord::Migration[6.0]
  def change
    create_table :integration_processes do |t|
      t.string :external_code
      t.integer :store_id
      t.float :sub_total
      t.float :delivery_fee
      t.float :total
      t.string :country
      t.string :state
      t.string :city
      t.string :district
      t.string :street
      t.string :complement
      t.float :latitude
      t.float :longitude
      t.datetime :dt_order_create
      t.string :postal_code
      t.string :number

      t.timestamps
    end
  end
end
