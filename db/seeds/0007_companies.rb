return if Company.count > 0

rows = CSV.read(Rails.root.join('db/seeds/nasdaq_100_companies.csv'))

rows.each { |row| Company.create(symbol: row[0], name: row[1]) }
