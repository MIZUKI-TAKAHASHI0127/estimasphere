class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :sales_quotation_id
      t.integer :purchase_quotation_id
      t.text :text
      t.timestamps
    end
  end
end
