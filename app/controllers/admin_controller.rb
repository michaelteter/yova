class AdminController < ApplicationController
  def foo
    # c = Company.first

    # r = PerformanceCalcService.calc_returns(timeseries: c.timeseries_hash)
    # PerformanceCalcService.calc_all_returns_for_all_assets
    twrs = PerformanceCalcService.current_portfolio_performance(client_id: 1)

    render json: twrs.map { |x| x.round(4) }
  end
end
