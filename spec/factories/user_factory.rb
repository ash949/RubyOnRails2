FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "user_f_n#{n}" }
    sequence(:last_name) { |n| "user_l_n#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    password '123123'
    admin false

    factory :admin do
      admin true
    end
  end
end