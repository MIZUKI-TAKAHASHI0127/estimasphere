FactoryBot.define do
  factory :sales_quotation_item do
    association :sales_quotation
    association :unit
    association :category
    item_name { "Sample Item" }
    quantity { Faker::Number.between(from: 1, to: 100) }
    unit_price { Faker::Number.between(from: 100, to: 10000) }
    note { "Sample Note" }
  end
end
