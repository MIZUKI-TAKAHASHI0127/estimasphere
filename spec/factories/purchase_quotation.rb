FactoryBot.define do
  factory :purchase_quotation do
    sequence(:quotation_number) { |n| "P#{Date.today.strftime('%Y%m%d')}-#{sprintf('%03d', n)}" }
    association :customer
    association :user
    request_date { Date.today }
    quotation_date { Date.today }
    quotation_due_date { Date.today + 7.days }
    delivery_date { Date.today + 14.days }

    factory :purchase_quotation_with_items do
      transient do
        items_count { 3 } # ネストされたSalesQuotationItemの数を指定できます
      end

      after(:create) do |purchase_quotation, evaluator|
        create_list(:purchase_quotation_item, evaluator.items_count, purchase_quotation: purchase_quotation)
      end
    end
  end
end