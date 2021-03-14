class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :purpose
      t.string :message, null: false

      t.timestamps
    end
  end
end
