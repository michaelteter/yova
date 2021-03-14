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
end
