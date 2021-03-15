class Timeseries::FetchDayWorker
  include Sidekiq::Worker

  def perform
    # Currently this is only done once in db/seeds/0010_timeseries.rb

    # Future:
    #   Fetch timeseries for all companies
    #     Store in YYYY_MM_DD_symbol.json files
    #   DB load new data from all timeseries files for given date

    true
  end
end
