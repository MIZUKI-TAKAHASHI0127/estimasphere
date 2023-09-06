FactoryBot.define do
  factory :category do
    sequence(:category_name) { |n| "Unit #{n}" }
  end
end