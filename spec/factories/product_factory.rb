FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product #{n}" }
    sequence(:description) { |n| "product description #{n}" }
    price 500
  end
end