# frozen_string_literal: true

return if Timeseries.count > 0

TimeseriesData.fetch_all_timeseries

Dir[Rails.root.join('db/seeds/historical_timeseries/*.json')].each do |file|
  TimeseriesData.db_store_timeseries(json_source_filename: file)
end
