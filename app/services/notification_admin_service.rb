# frozen_string_literal: true

module NotificationAdminService
  extend self

  def create_notification(purpose:, message:, client_ids:)
    result = Notification.transaction do
      notif = Notification.create(purpose: purpose, message: message)

      client_ids.each do |client_id|
        ClientNotification.create(uuid:            SecureRandom::uuid,
                                  notification_id: notif.id,
                                  client_id:       client_id)
      end
    end
  end

  def alert_clients(notification_id:)

  end
end
