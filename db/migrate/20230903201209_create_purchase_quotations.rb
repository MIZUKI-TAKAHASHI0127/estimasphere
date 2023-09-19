class CreatePurchaseQuotations < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_quotations do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :quotation_number, null: false
      t.date :request_date, null: false
      t.date :quotation_date, null: false
      t.date :quotation_due_date, null: false
      t.date :delivery_date, null: false
      t.string :handover_place
      t.string :trading_conditions
      t.references :representative, foreign_key: true
      t.timestamps
    end
    add_index :purchase_quotations, :quotation_number, unique: true
  end
end
