FactoryBot.define do
  factory :client do
    name { Faker::Company.unique.name }
    uuid { SecureRandom::uuid }
    notification_method { 'web_hook' }
    notification_target {
      "https://#{Faker::Alphanumeric.alpha(number: 10)}.com/notification_alert"
    }
    public_key { Faker::Alphanumeric.alphanumeric(number: 50) }
    api_key { Faker::Alphanumeric.alphanumeric(number: 50) }
  end
end
