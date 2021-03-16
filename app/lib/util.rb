# frozen_string_literal: true

module Util
  extend self

  def distinct_rand_ints(n_ints:, min_int: 0, max_int:)
    if n_ints > max_int - min_int + 1
      raise ArgumentError.new('available range of ints must be more numerous than n_ints')
    end

    ints = Set.new
    while ints.length < n_ints
      ints << rand(min_int..max_int)
    end

    ints
  end

  def nearest_prior_date(target_date:, dates:, presorted: false)
    # Given a list of dates (presorted, or we sort if not),
    #   return the closest date which is <= target_date.

    dates.sort! unless presorted

    return if dates.first > target_date # target_date precedes the available data

    selected_date = target_date
    dates.each do |dt|
      return dt if dt >= target_date

      selected_date = dt
    end

    selected_date
  end
end
