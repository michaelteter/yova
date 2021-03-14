class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :uuid, limit: 36, unique: true, null: false
      t.string :notification_method
      t.string :notification_target
      t.string :public_key
      t.string :api_key, null: false

      t.timestamps
    end

    add_index :clients, :name
  end
end
