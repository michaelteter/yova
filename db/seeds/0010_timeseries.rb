# frozen_string_literal: true

# Where data exists, we skip to the next symbol.

def seed_timeseries
  filenames = TimeseriesData.existing_data_filenames

  Company.symbols.each do |symbol|
    next if Timeseries.exists?(symbol: symbol)

    puts "Seeding #{symbol}"

    # sort and [-1] ensure we get the most recent file in the case where there are multiple date_symbol.json
    filename = filenames.sort.filter { |f| TimeseriesData.data_filename_for?(filename: f, symbol: symbol) }[-1]
    if filename
      puts "Using existing data file: #{filename}"
      TimeseriesData.data_file_to_db(data_filename: filename)
    else
      data = TimeseriesData.fetch_remote_timeseries(symbol: symbol)
      TimeseriesData.data_to_file(data: data)
      TimeseriesData.data_to_db(data: data)
      sleep(15)
    end
  end
end

seed_timeseries
