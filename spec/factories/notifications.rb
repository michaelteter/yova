FactoryBot.define do
  factory :notification do
    purpose { 'twr_updated' }
    message { 'You have an unread notification.' }
  end
end
