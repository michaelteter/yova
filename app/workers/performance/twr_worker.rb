class Performance::TwrWorker
  include Sidekiq::Worker

  def perform
    # Calculate the TWR for each portfolio (daily, based on sidekiq cron schedule)

    # Update all asset returns
    PerformanceCalcService.calc_all_returns_for_all_assets

    # Update portfolio returns
    PerformanceCalcService.calc_all_returns_for_all_porfolios
  end
end
