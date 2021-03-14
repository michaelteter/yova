# frozen_string_literal: true

require 'rails_helper'

describe Util do
  describe 'distinct_rand_ints()' do
    it 'raises exceptions on unreasonable arguments' do
      expect {
        Util.distinct_rand_ints(n_ints: 10, max_int: 8)
      }.to raise_exception(ArgumentError)

      expect {
        Util.distinct_rand_ints(n_ints: 0, min_int: 20, max_int: 18)
      }.to raise_exception(ArgumentError)
    end

    it 'creates a list of unique random integers' do
      # pointless but possible request for no integers :)
      expect(Util.distinct_rand_ints(n_ints: 0, max_int: 100).blank?).to eq(true)

      ints = Util.distinct_rand_ints(n_ints: 10, min_int: 1, max_int: 10)
      expect(ints.is_a?(Set)).to eq(true) # That was our uniqueness test :)
      expect(ints.length).to eq(10)

      ints = Util.distinct_rand_ints(n_ints: 1, max_int: 0)
      expect(ints.length).to eq(1)
      expect(ints.first).to eq(0)
    end
  end

end
