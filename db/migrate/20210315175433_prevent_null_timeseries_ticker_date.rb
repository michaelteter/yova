class PreventNullTimeseriesTickerDate < ActiveRecord::Migration[5.2]
  def change
    change_column_null :timeseries, :ticker_date, false
  end
end
