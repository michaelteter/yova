class Performance::TwrWorker
  include Sidekiq::Worker

  def perform
    # Calculate the TWR for each portfolio (daily, based on sidekiq cron schedule)

    # Update all asset returns.
    # Normally there would be new daily data each night, and this step would make sense.
    #   However, new data is not being fetched.  So once this has been run one time,
    #   it will discover existing data and skip.
    # To test this job, delete all rows from asset_performances table and then
    #   manually launch this job from the /_sidekiq/cron page.
    PerformanceCalcService.calc_all_returns_for_all_assets

    # Update portfolio returns
    # Not yet implemented.  It is so fast that it can be calculated on demand by
    #   the client.  The results could be stored in portfolio_performances table for that end_date
    #   and then fetched rather than recalculating (since the numbers will not change
    #   for the same period), but that is not yet implemented.
    # PerformanceCalcService.calc_all_returns_for_all_porfolios
  end
end
