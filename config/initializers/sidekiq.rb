# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

REDIS_URL = 'redis://localhost:6379'
REDIS_NAMESPACE = 'yova_api'

DEFAULT_CONFIG = { url: REDIS_URL, namespace: REDIS_NAMESPACE, id: nil }.freeze

Sidekiq.configure_server { |cfg| cfg.redis = DEFAULT_CONFIG }
Sidekiq.configure_client { |cfg| cfg.redis = DEFAULT_CONFIG }

CRON_JOBS = {
  # Get updated timeseries every day at 00:30
  fetch_day_timeseries: { class: Timeseries::FetchDayWorker.name,
                          cron: '30 0 * * *',
                          status: 'disabled' },

  # Calculate portfolio returns every day at 04:00
  calc_portfolio_perfs: { class: Performance::TwrWorker.name,
                          cron: '0 3 * * *',
                          status: 'disabled'
  },
}

Sidekiq::Cron::Job.load_from_hash! CRON_JOBS if Sidekiq.server?
