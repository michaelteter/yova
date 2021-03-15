FactoryBot.define do
  factory :portfolio_performance do
    portfolio { nil }
    twr_calendar_month { 0.0 }
    twr_30_days { 0.0 }
    period_end { '2021-03-14' }
    assets_data { '{}' }
  end
end
