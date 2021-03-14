# frozen_string_literal: true

module TimeseriesData
  extend self

  ROOT_DIR = Rails.root.join('db/seeds/historical_timeseries')

  ALPHAVANTAGE_KEY = '30YZBNAXRIYLI4I5'

  def fetch_all_timeseries
    symbols = Company.all.pluck(:symbol)

    # AlphaVantage only allows 5reqs/min, so be safe with a 15+sec delay
    symbols.each { |symbol| fetch_symbol_timeseries(symbol) && sleep(17) }
  end

  def db_store_timeseries(json_source_filename:)
    json_data = JSON.parse(File.read(json_source_filename) || '') || return

    Timeseries.transaction do
      json_data['Time Series (Daily)'].each do |ts|
        db_store_timeseries_event(symbol: json_data['Meta Data']['2. Symbol'],
                                  ticker_date: ts.first,
                                  source_data: ts[1])
      end
    end
  end

  def fetch_symbol_timeseries(symbol)
    file = ROOT_DIR.join("#{symbol}.json")
    return if FileTest.exists?(file)

    timeseries = Alphavantage::Timeseries.new(symbol: symbol, key: ALPHAVANTAGE_KEY)
    return unless timeseries

    File.write(file, JSON.dump(timeseries.output))
  end

  def build_timeseries(source:)
    { open:   source['1. open']&.to_d,
      high:   source['2. high']&.to_d,
      low:    source['3. low']&.to_d,
      close:  source['4. close']&.to_d,
      volume: source['5. volume']&.to_i }
  end

  def db_store_timeseries_event(symbol:, ticker_date:, source_data:)
    ts_data = build_timeseries(source: source_data)

    existing_ts = Timeseries.where(symbol: symbol, ticker_date: ticker_date).first
    if existing_ts
      # Currently this is unnecessary.  Later we will implement daily updates of
      #   data based on new fetches.
      # existing_ts.update_columns(ts_data)
      return
    else
      Timeseries.create(ts_data.merge(symbol: symbol, ticker_date: ticker_date))
    end
  end
end
