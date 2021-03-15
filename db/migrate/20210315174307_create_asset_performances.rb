class CreateAssetPerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_performances do |t|
      t.references :company, foreign_key: true
      t.date :ticker_date, null: false
      t.numeric :day_twr, null: false

      t.timestamps
    end

    add_index :asset_performances, :ticker_date
    add_index :asset_performances, [:company_id, :ticker_date], unique: true
  end
end
