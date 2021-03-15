# frozen_string_literal: true

module TimeseriesData
  class TimeseriesDataFileException < StandardError; end
  class TimeseriesDataRemoteFetchException < StandardError; end

  extend self

  TIMESERIES_DATA_ROOT_DIR = Rails.root.join('data/historical_timeseries')

  ALPHAVANTAGE_KEY = Rails.configuration.x.data_providers.alphavantage_key

  METADATA_KEY = 'Meta Data'

  def data_file_to_db(data_filename:)
    # Load timeseries batch data from file and store in db.

    data_to_db(data: data_from_file(data_filename: data_filename))
  end

  def existing_data_filenames
    Dir[File.join(TIMESERIES_DATA_ROOT_DIR, '*.json')]
  end

  def data_filename_for?(filename:, symbol:)
    # Does the provided filename represent data for this symbol?

    # Ensure the exact symbol matches, but allow for prefix (such as '2021-01-01_')
    filename.match?(/(^|\/|_)#{symbol}.json/)
  end

  def data_from_file(data_filename:, fail_hard: true)
    # Given a filename, attempt to load timeseries data.
    # Raise an exception if fail_hard and no data exists.

    data = JSON.parse(File.read(data_filename) || '')
    raise TimeseriesDataFileException.new("No data found in #{data_filename}.") if fail_hard && data.blank?

    data
  end

  def data_to_file(data:)
    # Store timeseries batch data to file.
    # Filename is determined by metadata within data.

    datestr = data_last_refreshed_date(data: data).to_s
    symbol = data_symbol(data: data)
    filename = File.join(TIMESERIES_DATA_ROOT_DIR, "#{datestr}_#{symbol}.json")

    File.write(filename, JSON.dump(data))
  end

  def data_to_db(data:)
    # Store timeseries batch data to db.
    # Do not overwrite any existing events.

    # db_last_updated = Timeseries.where(symbol: symbol).order(ticker_date: :desc).limit(1).pluck(:ticker_date).first
    symbol = data_symbol(data: data)
    company_id = Company.where(symbol: symbol).pluck(:id).first

    # Timeseries.transaction do
      data['Time Series (Daily)'].each do |ts|
        timeseries_event_to_db(symbol: symbol,
                               company_id: company_id,
                               ticker_date: ts.first,
                               event_data: ts[1])
      end
    # end
  end

  def data_last_refreshed_date(data:)
    data&.dig(METADATA_KEY, '3. Last Refreshed')
  end

  def data_symbol(data:)
    data&.dig(METADATA_KEY, '2. Symbol')
  end

  def fetch_remote_timeseries(symbol:, fail_hard: true)
    # Get timeseries data from remote source.
    # Raise exception if fail_hard and no data found.

    data = Alphavantage::Timeseries.new(symbol: symbol, key: ALPHAVANTAGE_KEY)
    raise TimeseriesDataRemoteFetchException.new("No data found for #{symbol}.") if fail_hard && data.blank?

    data.output
  end

  def build_timeseries(source:)
    { open:   source['1. open']&.to_d,
      high:   source['2. high']&.to_d,
      low:    source['3. low']&.to_d,
      close:  source['4. close']&.to_d,
      volume: source['5. volume']&.to_i }
  end

  def timeseries_event_to_db(symbol:, company_id:, ticker_date:, event_data:)
    # Store one timeseries event to db.
    # Return nil if record already exists.

    ts_data = build_timeseries(source: event_data)

    return if Timeseries.exists?(symbol: symbol, ticker_date: ticker_date)

    Timeseries.create(ts_data.merge(symbol: symbol, company_id: company_id, ticker_date: ticker_date))
  end
end
