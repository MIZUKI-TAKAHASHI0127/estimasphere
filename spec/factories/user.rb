FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    # ランダムで生成する際、英数字になるよう'1a'追加
    password { '1a' + Faker::Internet.unique.password(min_length: 6) }
    password_confirmation { password }
    last_name { '佐藤' }
    first_name { '愛' }
  end
end