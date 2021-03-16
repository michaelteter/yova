FactoryBot.define do
  factory :notification do
    uuid { SecureRandom::uuid }
    notification_alert_id { nil }
    client_id { nil }
    notified_at { nil }
    fetched_at { nil }
  end
end
