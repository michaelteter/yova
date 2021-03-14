FactoryBot.define do
  factory :timeseries do
    symbol { Faker::Alphanumeric.unique.alpha(number: 6).upcase }
    ticker_date { Date.today.to_s }
    open { BigDecimal(Faker::Number.decimal(l_digits: 3, r_digits: 4), 12) }
    high { open }
    low { open }
    close { open }
    volume { rand(1000..1000000) }
  end
end
