FactoryBot.define do
  factory :portfolio_performance do
    period_end { Date.today }
    twr_1_day { 1 }
    twr_30_days { 1 }
    twr_1_cal_mo { 1 }
    twr_mtd { 1 }
    twr_ytd { 1 }
    client_id { nil }
    assets_data { '{}' }
  end
end
