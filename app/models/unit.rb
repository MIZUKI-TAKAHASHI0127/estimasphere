class Unit < ApplicationRecord
  has_many :sales_quotation_items
  
  validates :unit_name, uniqueness: { case_sensitive: true }
end
