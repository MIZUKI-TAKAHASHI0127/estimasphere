class Representative < ApplicationRecord
  belongs_to :customer
  has_many :sales_quotations
  validates :department_name, presence: true, unless: :any_other_field_present?
  validates :representative_name, presence: true, unless: :any_other_field_present?
  validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid. Must be 10 or 11 digits.", allow_blank: true }
  validates :email, presence: true, unless: :any_other_field_present?
  validate :department_name_and_representative_name_are_not_both_blank

  private

  def any_other_field_present?
    department_name.present? || representative_name.present? || email.present?
  end

  def department_name_and_representative_name_are_not_both_blank
    if department_name.blank? && representative_name.blank?
      errors.add(:base, "At least one of the Department or Representative Name should be present.")
    end
  end
end