class Company < ApplicationRecord
  has_many :timeseries

  def timeseries_hash
    # This is acceptable for now, but eventually this will be too much data.
    # By then, much of this codebase would need to be refactored for scaling purposes.
    timeseries.pluck(%i[ticker_date close]).to_h
  end

  def self.symbols
    all.pluck(:symbol)
  end
end
