class RenameNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_table :notifications, :notification_alerts
  end
end
