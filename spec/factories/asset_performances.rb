FactoryBot.define do
  factory :asset_performance do
    company_id { 1 }
    ticker_date { Date.today }
    return_1_day { 1 }
    return_30_days { 1 }
    return_1_cal_mo { 1 }
    return_mtd { 1 }
    return_ytd { 1 }
  end
end
