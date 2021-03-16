class PortfolioPerformancesController < ApplicationController
  def show
    client = Client.find_by(params[:uuid])
    render json: nil, status: 404 and return unless client

    pperfs = PortfolioPerformance.where(client_id: client.id)
                                 .order(period_end: :desc)
                                 .limit(1)
                                 .select(%i[period_end twr_1_cal_mo twr_30_days twr_mtd twr_ytd twr_1_day])
                                 .first

    pperfs ||= PerformanceCalcService.current_portfolio_performance(client_id: client.id)

    render json: pperfs
  end
end
