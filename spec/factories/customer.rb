FactoryBot.define do
  factory :customer do
    sequence(:customer_code) { |n| "Code#{n}" }
    customer_name { 'Test Company' }
    address { '123 Test Street, Test City' }
    phone_number { "0#{rand(1..9)}0-#{rand(1_000..9_999)}-#{rand(1_000..9_999)}" } # このフォーマットはより一般的な電話番号の形式として変更されています
  end
end
