class Notification < ApplicationRecord
  belongs_to :notification_alert
  belongs_to :client
end
