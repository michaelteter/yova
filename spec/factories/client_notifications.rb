FactoryBot.define do
  factory :notification do
    uuid { SecureRandom::uuid }
    notification { nil }
    client { nil }
    notified_at { nil }
    fetched_at { nil }
  end
end
