class RenameNotificationsFkey < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :notification_id, :notification_alert_id
  end
end
