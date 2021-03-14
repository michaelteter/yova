FactoryBot.define do
  factory :client_notification do
    uuid { SecureRandom::uuid }
    notification { nil }
    client { nil }
    notified_at { nil }
    fetched_at { nil }
  end
end
