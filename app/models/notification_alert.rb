class NotificationAlert < ApplicationRecord
  has_many :notifications
  has_many :clients, through: :notifications
end
