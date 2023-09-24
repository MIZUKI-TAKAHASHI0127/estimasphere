class PurchaseQuotation < ApplicationRecord
  belongs_to :customer
  belongs_to :user
  has_many :purchase_quotation_items, inverse_of: :purchase_quotation, dependent: :destroy
  validates_associated :purchase_quotation_items
  belongs_to :representative, optional: true
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :purchase_quotation_items, reject_if: :all_blank, allow_destroy: true
  validates :quotation_number, uniqueness: { case_sensitive: true }
  validates :customer_id, :user_id, :request_date, :quotation_date, :quotation_due_date, presence: true
  validate :quotation_due_date_after_quotation_date

  def generate_new_quotation_number
    date_prefix = Date.today.strftime('P%Y%m%d-')
    last_quotation = PurchaseQuotation.where('quotation_number LIKE ?', "#{date_prefix}%").order(:quotation_number).last
    if last_quotation.nil?
      "#{date_prefix}001"
    else
      number = last_quotation.quotation_number.split('-').last.to_i
      "#{date_prefix}#{sprintf('%03d', number + 1)}"
    end
  end

  private

  def quotation_due_date_after_quotation_date
    return if quotation_due_date.blank? || quotation_date.blank?

    if quotation_due_date < quotation_date
      errors.add(:quotation_due_date, "must be after the quotation date")
    end
  end
end