class CompanyInfo < ApplicationRecord
  validates :company_name, :postcode, :address, :phone_number, :fax_number, presence: true
  after_create :ensure_single_instance
  
  validates :phone_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{3,4}\z/, message: "is invalid. Enter the phone number with hyphens." }
  validates :fax_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{3,4}\z/, message: "is invalid. Enter the phone number with hyphens." }
  validates :postcode, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
  private

  def ensure_single_instance
    throw :abort if CompanyInfo.count > 1
  end
end
