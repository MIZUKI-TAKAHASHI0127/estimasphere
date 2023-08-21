FactoryBot.define do
  factory :customer do
    customer_code { "Code#{rand(100)}" }
    customer_name { 'Test Company' }
    address { '123 Test Street, Test City' }
    phone_number { '09012345678' }
  end
end
