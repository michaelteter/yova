class FixPreviousMigrationMistake < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :notification_alert, foreign_key: true
  end
end
