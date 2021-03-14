class CreateClientNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :client_notifications do |t|
      t.string :uuid, limit: 36, unique: true, null: false
      t.references :notification, foreign_key: true
      t.references :client, foreign_key: true
      t.timestamp :notified_at
      t.timestamp :fetched_at

      t.timestamps
    end
  end
end
