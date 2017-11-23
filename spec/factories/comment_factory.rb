FactoryBot.define do
  factory :comment do
    body 'Comment body'
    rating [1, 2, 3, 4, 5].sample
    user
    product
  end
end
