class Notifications::AlertWorker
  include Sidekiq::Worker

  def perform(notification_alert_id:)
    NotificationAdminService.alert_clients(notification_alert_id: notification_alert_id, as_job: false)
  end
end
