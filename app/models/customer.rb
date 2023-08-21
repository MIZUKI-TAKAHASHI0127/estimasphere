class Customer < ApplicationRecord
  has_many :representatives, inverse_of: :customer
  accepts_nested_attributes_for :representatives, reject_if: :all_blank, allow_destroy: true

  validates :customer_name, presence: true
  validates :customer_code, uniqueness: { case_sensitive: true }, format: { with: /\A[a-zA-Z0-9\-]+\z/, message: "can only contain alphanumeric characters and hyphens" },
 length: { maximum: 10 }, allow_blank: true
  validates :address, presence: true
  validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid. Must be 10 or 11 digits."}

  def self.search(search)
    if search != ""
      where('customer_name LIKE(?)', "%#{search}%")
    else
      all
    end
  end
end
