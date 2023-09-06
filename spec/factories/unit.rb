FactoryBot.define do
  factory :unit do
    sequence(:unit_name) { |n| "Unit #{n}" } # 連番の単位名を生成
  end
end