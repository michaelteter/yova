# frozen_string_literal: true

module NotificationService
  extend self

  def create_and_alert_clients(params)
    notification_alert_id = create(purpose:    params[:purpose],
                                   message:    params[:message],
                                   client_ids: params[:client_ids])

    alert_clients(notification_alert_id: notification_alert_id) if notification_alert_id

    notification_alert_id
  end

  def create(purpose:, message:, client_ids:)
    NotificationAlert.transaction do
      na = NotificationAlert.create(purpose: purpose, message: message)
      client_ids.each do |client_id|
        Notification.create(notification_alert: na, client_id: client_id, uuid: SecureRandom::uuid)
      end

      na.id
    end
  end

  def alert_clients(notification_alert_id:, as_job: false)
    # notify clients as appropriate (email or web_hook if configured in Client)

    Notifications::AlertWorker.perform_async(notification_alert_id: notification_alert_id) and return if as_job

    na = NotificationAlert.find(notification_alert_id)

    na.clients.each do |client|
      case client.notification_method
      when 'email'
        # we don't send emails yet...
      when 'web_hook'
        notif = Notification.where(notification_alert_id: notification_alert_id, client_id: client.id).first
        # POST to client.notification_target, including notif.uuid
      end
    end

    true
  end
end
