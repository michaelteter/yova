class Performance::TwrWorker
  include Sidekiq::Worker

  def perform
    # Calculate the TWR for each portfolio (daily, based on sidekiq cron schedule)

    true
  end
end
