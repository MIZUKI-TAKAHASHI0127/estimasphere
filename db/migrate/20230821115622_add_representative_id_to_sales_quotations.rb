class AddRepresentativeIdToSalesQuotations < ActiveRecord::Migration[7.0]
  def change
    add_column :sales_quotations, :representative_id, :integer
  end
end
