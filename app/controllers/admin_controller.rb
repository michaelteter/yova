class AdminController < ApplicationController
  def foo
    c = Company.first

    r = PerformanceCalcService.calc_returns(timeseries: c.timeseries_hash)

    render plain: r.inspect
  end
end
