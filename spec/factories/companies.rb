FactoryBot.define do
  factory :company do
    symbol { Faker::Alphanumeric.unique.alpha(number: 6).upcase }
    name { Faker::Company.unique.name }
  end
end
