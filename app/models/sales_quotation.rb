class SalesQuotation < ApplicationRecord
  belongs_to :customer
  belongs_to :user
  has_many :sales_quotation_items, inverse_of: :sales_quotation, dependent: :destroy
  validates_associated :sales_quotation_items
  belongs_to :representative, optional: true
  has_many :comments

  accepts_nested_attributes_for :sales_quotation_items, reject_if: :all_blank, allow_destroy: true
  validates :quotation_number, uniqueness: { case_sensitive: true }
  validates :customer_id, :user_id, :request_date, :quotation_date, :quotation_due_date, presence: true
  validate :quotation_due_date_after_quotation_date

  private

  def quotation_due_date_after_quotation_date
    return if quotation_due_date.blank? || quotation_date.blank?

    if quotation_due_date < quotation_date
      errors.add(:quotation_due_date, "must be after the quotation date")
    end
  end
end