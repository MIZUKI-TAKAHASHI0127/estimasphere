class RemoveQuotationIdsFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :sales_quotation_id, :integer
    remove_column :comments, :purchase_quotation_id, :integer
  end
end
