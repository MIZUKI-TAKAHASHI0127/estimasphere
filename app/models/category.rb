class Category < ApplicationRecord
  has_many :sales_quotation_items

  validates :category_name, uniqueness: { case_sensitive: true }
end