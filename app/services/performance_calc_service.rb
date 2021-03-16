# frozen_string_literal: true

module PerformanceCalcService
  extend self

  def raw_asset_perf_data(fetch_cols:, client_id:, end_date:)
    q = "select
          weight,
          #{fetch_cols.join(',')}
         from
          portfolios p
          join asset_performances ap on p.company_id = ap.company_id
         where
          p.client_id = ?
          and ap.ticker_date = ?"

    AssetPerformance.connection.exec_query(
      AssetPerformance.sanitize_sql_array([q, client_id, end_date])
    ).rows
  end

  def current_portfolio_performance(client_id:, end_date: nil, force_update: true)
    end_date ||= AssetPerformance.maximum(:ticker_date)

    colnames = %i[return_1_day
                  return_1_cal_mo
                  return_30_days
                  return_mtd
                  return_ytd]

    rows = raw_asset_perf_data(fetch_cols: colnames, client_id: client_id, end_date: end_date)

    # DB numeric cols are being returned as strings, which is not ideal.
    # However, they are fixed precision and scale, so they are safe to cast.
    # Using standard ActiveRecord methods doesn't have this problem, but it
    #   is much slower and much more memory hungry for large datasets.

    # It is also more dangerous to use numeric offsets for field access,
    #   but "performance".  All of this could be done safer and clearer.

    twrs = Array.new(5, 0.0)

    rows.each do |row|
      weight = row[0].to_d
      row[1..-1].each_with_index do |col, i|
        twrs[i] += weight * (col&.to_d || 0)
      end
    end

    colnames.zip(twrs).to_h.merge(period_end: end_date)
  end

  def calc_all_returns_for_all_assets
    # Calculate the returns for all possible periods within the available timeseries of all companies (assets).
    Company.all.each { |c| calc_all_returns_for_asset(company: c) }
  end

  def calc_all_returns_for_asset(company:)
    # Given a company (asset), calculate the returns for all possible periods within the available timeseries.

    # Work from ticker_date descending so the process short circuits when it hits already calculated data.
    timeseries = company.timeseries_hash

    timeseries.keys.sort.reverse.each do |end_date|
      return unless calc_returns_to_db(company: company, end_date: end_date, timeseries: timeseries)
    end
  end

  def calc_returns_to_db(company:, end_date: Date.today, timeseries: nil)
    # Calculate and store the various period returns for a given company (asset) and period.
    # If timeseries is supplied, use it instead of pulling it from company.
    #   (This function may be called repeatedly for different periods over the same data,
    #   so preventing unnecessary fetches is recommended.)
    # Do this for the specified end date, or default with today as the end of the period.
    # Skip if performance record exists

    return if AssetPerformance.exists?(company_id: company.id, ticker_date: end_date)

    timeseries ||= company.timeseries_hash

    r = PerformanceCalcService.calc_returns(timeseries: timeseries, end_date: end_date)
    r.merge!(company_id: company.id, ticker_date: end_date)

    AssetPerformance.create(r)
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
                                  presorted:  true)&.round(4)]
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

    return if start_date.nil?

    ts = timeseries.filter { |k, _v| k >= start_date && k <= end_date }

    # ts is now [[date, close], ...], sorted and filtered
    v0 = ts[start_date]
    v1 = ts[end_date]

    (v1 - v0) / v0
  end
end
