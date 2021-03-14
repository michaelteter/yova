class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :symbol, limit: 20, unique: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
