class CreateSalesQuotationItems < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_quotation_items do |t|
      t.bigint :sales_quotation_id, null: false, foreign_key: {to_table: :sales_quotations}
      t.string :item_name, null: false
      t.integer :quantity, null: false
      t.references :category, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true
      t.integer :unit_price, null: false
      t.string :note
      t.integer :result_id

      t.timestamps
    end
  end
end
