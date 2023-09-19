class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
         VALID_NAME_REGEX = /\A[ぁ-んァ-ン一-龥]+\z/.freeze
       
         validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'Include both letters and numbers' }
         validates :last_name, presence: true, format: { with: VALID_NAME_REGEX, message: 'is invalid' }
         validates :first_name, presence: true, format: { with: VALID_NAME_REGEX, message: 'is invalid' }
  
   has_many :sales_quotations
   has_many :purchase_quotations

end
