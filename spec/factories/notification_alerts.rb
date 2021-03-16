FactoryBot.define do
  factory :notification_alert do
    purpose { 'twr_updated' }
    message { 'You have an unread notification.' }
  end
end
