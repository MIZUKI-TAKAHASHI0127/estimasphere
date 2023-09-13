require 'rails_helper'

RSpec.describe 'Sales Quotation', type: :model do
  describe 'generate_new_quotation_number' do
    it '当日の初めての見積番号が正しく生成されること' do
      today = Date.today
      expected_quotation_number = "S#{today.strftime('%Y%m%d')}-001"
      sales_quotation = SalesQuotation.new
      generated_quotation_number = sales_quotation.generate_new_quotation_number
      expect(generated_quotation_number).to eq(expected_quotation_number)
    end

    it '当日の2つ目の見積番号が正しく生成されること' do
      today = Date.today
      existing_quotation_number = "S#{today.strftime('%Y%m%d')}-001"
      FactoryBot.create(:sales_quotation, quotation_number: existing_quotation_number)
      expected_quotation_number = "S#{today.strftime('%Y%m%d')}-002"
      sales_quotation = SalesQuotation.new
      generated_quotation_number = sales_quotation.generate_new_quotation_number
      expect(generated_quotation_number).to eq(expected_quotation_number)
    end
  end

  describe '見積作成' do
    it '正しいパラメータで見積を作成できること' do
      customer = FactoryBot.create(:customer)
      user = FactoryBot.create(:user)
      sales_quotation_params = {
        quotation_number: nil,
        customer_id: customer.id,
        user_id: user.id,
        request_date: Date.today,
        quotation_date: Date.today,
        quotation_due_date: Date.today + 7.days,
        sales_quotation_items_attributes: [
          {
            category_id: FactoryBot.create(:category).id,
            item_name: 'Item 1',
            quantity: 10,
            unit_id: FactoryBot.create(:unit).id,
            unit_price: 100
          },
          {
            category_id: FactoryBot.create(:category).id,
            item_name: 'Item 2',
            quantity: 5,
            unit_id: FactoryBot.create(:unit).id,
            unit_price: 50
          }
        ]
      }
    
      sales_quotation = SalesQuotation.new(sales_quotation_params)
      sales_quotation.generate_new_quotation_number # 生成メソッドを呼び出す
      expect(sales_quotation).to be_valid
    end
    

    context '新規見積作成ができない場合' do
      it '必要なパラメータが不足しているとエラーになること' do
        sales_quotation = SalesQuotation.new
        sales_quotation.valid?
        expect(sales_quotation.errors[:customer_id]).to include("can't be blank")
        expect(sales_quotation.errors[:user_id]).to include("can't be blank")
        expect(sales_quotation.errors[:request_date]).to include("can't be blank")
        expect(sales_quotation.errors[:quotation_date]).to include("can't be blank")
        expect(sales_quotation.errors[:quotation_date]).to include("can't be blank")
        
      end

      it '見積有効期限が見積日より前の場合、エラーになること' do
        customer = FactoryBot.create(:customer)
        user = FactoryBot.create(:user)
        sales_quotation_params = {
          quotation_number: nil,
          customer_id: customer.id,
          user_id: user.id,
          request_date: Date.today,
          quotation_date: Date.today,
          quotation_due_date: Date.today - 7.days, # 過去の日付
          sales_quotation_items_attributes: [
            {
              category_id: FactoryBot.create(:category).id,
              item_name: 'Item 1',
              quantity: 10,
              unit_id: FactoryBot.create(:unit).id,
              unit_price: 100
            }
          ]
        }
      
        sales_quotation = SalesQuotation.new(sales_quotation_params)
        sales_quotation.generate_new_quotation_number
        expect(sales_quotation).not_to be_valid
        expect(sales_quotation.errors[:quotation_due_date]).to include('must be after the quotation date')
      end
      

    
      it '顧客が選択されていないと作成できない' do
        sales_quotation = FactoryBot.build(:sales_quotation, customer_id: nil)
        expect(sales_quotation).not_to be_valid
        expect(sales_quotation.errors[:customer_id]).to include("can't be blank")
      end
      
      it '品名が入力されていないと作成できない' do
        sales_quotation_item = FactoryBot.build(:sales_quotation_item, item_name: nil)
        expect(sales_quotation_item).not_to be_valid
        expect(sales_quotation_item.errors[:item_name]).to include("can't be blank")
      end
      
      it '登録されたカテゴリーが選択されていないと作成できない' do
        customer = FactoryBot.create(:customer)
        user = FactoryBot.create(:user)

        sales_quotation_params = {
          quotation_number: nil,
          customer_id: customer.id,
          user_id: user.id,
          request_date: Date.today,
          quotation_date: Date.today,
          quotation_due_date: Date.today + 7.days,
          sales_quotation_items_attributes: [
            {
              category_id: nil, # カテゴリーIDをnilに設定
              item_name: 'Item 1',
              quantity: 10,
              unit_id: FactoryBot.create(:unit).id,
              unit_price: 100
            }
          ]
        }
      
        # カテゴリーが選択されていない状態で見積もりを作成
        sales_quotation_params[:sales_quotation_items_attributes][0][:category_id] = nil # カテゴリーIDをnilに設定
        sales_quotation = SalesQuotation.new(sales_quotation_params)
        expect(sales_quotation).not_to be_valid
        expect(sales_quotation.errors[:'sales_quotation_items.category']).to include("can't be blank")

      end


      it '登録された単位が選択されていないと作成できない' do
        customer = FactoryBot.create(:customer)
        user = FactoryBot.create(:user)
      
        sales_quotation_params = {
          quotation_number: nil,
          customer_id: customer.id,
          user_id: user.id,
          request_date: Date.today,
          quotation_date: Date.today,
          quotation_due_date: Date.today + 7.days,
          sales_quotation_items_attributes: [
            {
              category_id: FactoryBot.create(:category).id,
              item_name: 'Item 1',
              quantity: 10,
              unit_id: nil,
              unit_price: 100
            }
          ]
        }
      
        sales_quotation_params[:sales_quotation_items_attributes][0][:unit_id] = nil
        sales_quotation = SalesQuotation.new(sales_quotation_params)
        expect(sales_quotation).not_to be_valid
        expect(sales_quotation.errors[:'sales_quotation_items.unit']).to include("must exist")
      end
      
      
      
      
      
      it '数量が入力されていないと作成できない' do
        sales_quotation_item = FactoryBot.build(:sales_quotation_item, quantity: nil)
        expect(sales_quotation_item).not_to be_valid
        expect(sales_quotation_item.errors[:quantity]).to include("can't be blank")
      end
      
      it '登録された単位が選択されていないと作成できない' do
        sales_quotation_item = FactoryBot.build(:sales_quotation_item, unit_id: nil)
        expect(sales_quotation_item).not_to be_valid
        expect(sales_quotation_item.errors[:unit_id]).to include("can't be blank")
      end
      
      it '単価が入力されていないと作成できない' do
        sales_quotation_item = FactoryBot.build(:sales_quotation_item, unit_price: nil)
        expect(sales_quotation_item).not_to be_valid
        expect(sales_quotation_item.errors[:unit_price]).to include("can't be blank")
      end
    end
  end
end