require 'rails_helper'

RSpec.describe Customer, type: :model do
  before do
    @customer = FactoryBot.build(:customer)
  end

  describe '顧客新規登録' do
    context '新規登録がうまくいくとき' do
      it '全ての入力事項が、存在すれば登録できる' do
        expect(@customer).to be_valid
      end

      it '電話番号のフォーマットが適切であること' do
        expect(@customer.phone_number).to match(Customer::VALID_PHONE_NUMBER_REGEX)
      end

      it '企業名が空欄でなければ保存できる' do
        @customer.customer_name = 'テスト企業'
        expect(@customer).to be_valid
      end
      it '住所が空欄でなければ保存できる' do
        @customer.address = '東京都新宿区'
        expect(@customer).to be_valid
      end
      it '顧客コードが空欄でも保存できる' do
        @customer.customer_code = ''
        expect(@customer).to be_valid
      end
    end

    context '新規登録がうまくいかないとき' do
      it '顧客コードが重複すると保存できない' do
        @customer.save
        another_customer = FactoryBot.build(:customer, customer_code: @customer.customer_code)
        another_customer.valid?
        expect(another_customer.errors.full_messages).to include('Customer code has already been taken')
      end

      it '顧客コードが半角英数字でなければ保存できない' do
        @customer.customer_code = '顧客コード'
        @customer.valid?
        expect(@customer.errors.full_messages).to include('Customer code can only contain alphanumeric characters')
      end

      it '顧客コードが10文字以上では保存できない' do
        @customer.customer_code = 'abc12345678'
        @customer.valid?
        expect(@customer.errors.full_messages).to include('Customer code is too long (maximum is 10 characters)')
      end

      it '企業名が空欄だと保存できない' do
        @customer.customer_name = ' '
        @customer.valid?
        expect(@customer.errors.full_messages).to include("Customer name can't be blank")
      end

      it '住所が空欄だと保存できない' do
        @customer.address = ''
        @customer.valid?
        expect(@customer.errors.full_messages).to include("Address can't be blank")
      end
      it '電話番号が空欄だと保存できない' do
        @customer.phone_number = ''
        @customer.valid?
        expect(@customer.errors.full_messages).to include("Phone number is invalid")
      end
      
      it '電話番号が10桁または11桁の半角数字でなければ保存できない' do
        @customer.phone_number = '１２３-４５６-７８９０'
        @customer.valid?
        expect(@customer.errors.full_messages).to include("Phone number is invalid")
      end
      
      it '電話番号にハイフンがないと保存できないこと' do
        @customer.phone_number = '09012345678'
        @customer.valid?
        expect(@customer.errors.full_messages).to include("Phone number is invalid")
      end
  
      it '電話番号が12桁以上あると保存できないこと' do
        @customer.phone_number = '090-1234-56789'
        @customer.valid?
        expect(@customer.errors.full_messages).to include('Phone number is invalid')
      end

 
      it '電話番号が9桁以下では保存できないこと' do
        @customer.phone_number = '090-123-45'
        @customer.valid?
        expect(@customer.errors.full_messages).to include('Phone number is invalid')
      end
    end
  end
end