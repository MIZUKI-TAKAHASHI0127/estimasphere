class CreatePurchaseQuotationItems < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_quotation_items do |t|
      t.bigint :purchase_quotation_id, null: false, foreign_key: {to_table: :purchase_quotations}
      t.string :item_name, null: false
      t.integer :quantity, null: false
      t.references :category, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.integer :unit_price, null: false
      t.string :note
      t.string :result
      t.timestamps
    end
  end
end