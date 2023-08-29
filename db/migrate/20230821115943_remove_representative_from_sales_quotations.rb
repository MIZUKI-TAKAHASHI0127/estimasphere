class RemoveRepresentativeFromSalesQuotations < ActiveRecord::Migration[7.0]
  def change
    remove_column :sales_quotations, :representative
  end
end
