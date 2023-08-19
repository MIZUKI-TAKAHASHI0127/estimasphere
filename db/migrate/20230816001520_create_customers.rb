class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :customer_code
      t.string :customer_name, null: false
      t.string :address, null: false
      t.string :phone_number, null: false

      t.timestamps
    end
    add_index :customers, :customer_code, unique: true
  end
end