# frozen_string_literal: true

module PerformanceCalcService
  extend self

  def calc_returns_to_db(company:, end_date: Date.today, timeseries: nil, overwrite: false)
    # Calculate and store the various period returns for a given company (asset) and period.
    # If timeseries is supplied, use it instead of pulling it from company.
    #   (This function may be called repeatedly for different periods over the same data,
    #   so preventing unnecessary fetches is recommended.)
    # Do this for the specified end date, or default with today as the end of the period.
    # Skip if performance record exists and overwrite is false.

    perf_record = AssetPerformance.where(company_id: company.id, ticker_date: end_date).first
    return if perf_record and !overwrite

    timeseries ||= company.timeseries_hash

    r = PerformanceCalcService.calc_returns(timeseries: timeseries)
    r.merge!(company_id: company.id, ticker_date: end_date)

    exists ? AssetPerformance.create(r) : perf_record.update(r)
  end

  def calc_returns(timeseries:, end_date: Date.today)
    # Calculate the various period returns for a timeseries belonging to one asset/company.

    # Sort once only.
    timeseries = timeseries.sort.to_h

    end_date = Util.nearest_prior_date(target_date: end_date,
                                       dates:       timeseries_dates(timeseries: timeseries, presorted: true),
                                       presorted:   true)

    periods = {
      return_1_day:    end_date - 1.day,
      return_30_days:  end_date - 30.days,
      return_1_cal_mo: end_date - 1.month,
      return_mtd:      Date.new(end_date.year, end_date.month, 1),
      return_ytd:      Date.new(end_date.year, 1, 1)
    }

    periods.map do |period_name, start_date|
      [period_name, period_return(timeseries: timeseries,
                                  start_date: start_date,
                                  end_date:   end_date,
                                  presorted:  true).round(4)]
    end.to_h
  end

  def timeseries_dates(timeseries:, presorted: false)
    # Return the sorted dates from a timeseries.
    presorted ? timeseries.keys : timeseries.keys.sort!
  end

  def period_return_by_day(timeseries:, start_date:, end_date:, presorted: false)
    # Calculate the return over the period for a given asset (using the day by day method)

    prev_close = nil
    acc = 1

    timeseries.sort! unless presorted

    # If start_date was not a trading date, get the date of the prior trading day.
    start_date = Util.nearest_prior_date(target_date: start_date,
                                         dates:       timeseries_dates(timeseries: timeseries, presorted: true),
                                         presorted:   true)

    v0 = nil

    timeseries.filter_map { |k, v| v if k >= start_date && k <= end_date }.each do |v1|
      acc *= 1 + (v1 - v0) / v0 if v0

      v0 = v1
    end

    acc - 1
  end

  def period_return(timeseries:, start_date:, end_date:, presorted: false)
    # Calculate the return over the period for a given asset (using the simple start/end method)

    timeseries.sort! unless presorted

    # If start_date was not a trading date, get the date of the prior trading day.
    start_date = Util.nearest_prior_date(target_date: start_date,
                                         dates:       timeseries_dates(timeseries: timeseries, presorted: true),
                                         presorted:   true)

    ts = timeseries.filter { |k, _v| k >= start_date && k <= end_date }
    # ts is now [[date, close], ...], sorted and filtered
    v0 = ts[start_date]
    v1 = ts[end_date]

    (v1 - v0) / v0
  end

end
