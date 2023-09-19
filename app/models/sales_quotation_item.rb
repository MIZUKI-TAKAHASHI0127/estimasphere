class SalesQuotationItem < ApplicationRecord
  belongs_to :sales_quotation
  belongs_to :unit
  belongs_to :category
  belongs_to :result, class_name: 'Result', optional: true


  validates :sales_quotation, :category, :item_name, :unit_id, presence: true
  validates :quantity, :unit_price, presence: true, numericality: { greater_than: 0 }

end
