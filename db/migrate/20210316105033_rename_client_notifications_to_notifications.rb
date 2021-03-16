class RenameClientNotificationsToNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_table :client_notifications, :notifications
  end
end
