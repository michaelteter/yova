# frozen_string_literal: true

require 'rails_helper'

describe TimeseriesData do
  it 'converts source data for db insertion' do
    source = {
      '1. open'   => '123.4560',
      '2. high'   => '128.4400',
      '3. low'    => '122.0000',
      '4. close'  => '126.1000',
      '5. volume' => '8675309'
    }

    target = {
      open:   123.456,
      high:   128.44,
      low:    122,
      close:  126.1,
      volume: 8675309
    }

    expect(TimeseriesData.build_timeseries(source: source)).to eq(target)
  end
end
