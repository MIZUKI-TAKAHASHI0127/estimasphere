class Customer < ApplicationRecord
  has_many :sales_quotations
  has_many :purchase_quotations
  has_many :representatives, inverse_of: :customer
  accepts_nested_attributes_for :representatives, reject_if: :all_blank, allow_destroy: true

  validates :customer_name, presence: true
  validates :customer_code, uniqueness: true, allow_blank: true, length: { maximum: 10 }, format: { with: /\A[a-zA-Z0-9]+\z/, message: 'can only contain alphanumeric characters' }
  validates :address, presence: true
  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}-\d{4}-\d{4}|\d{2}-\d{3}-\d{4}|\d{2}-\d{4}-\d{4}|\d{3}-\d{2}-\d{4}|\d{3}-\d{3}-\d{4}|\d{4}-\d{1}-\d{4}|\d{4}-\d{2}-\d{4})\z|\A0[5789]0-\d{4}-\d{4}\z/
  validates :phone_number, format: { with: VALID_PHONE_NUMBER_REGEX, message: 'is invalid' }

  def self.search(search)
    if search != ""
      where('customer_name LIKE(?)', "%#{search}%")
    else
      all
    end
  end
end
