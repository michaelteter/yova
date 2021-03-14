class CreateTimeseries < ActiveRecord::Migration[5.2]
  def change
    create_table :timeseries do |t|
      t.string :symbol, limit: 20, null: false
      t.date :ticker_date
      t.decimal :open, precision: 12, scale: 4
      t.decimal :high, precision: 12, scale: 4
      t.decimal :low, precision: 12, scale: 4
      t.decimal :close, precision: 12, scale: 4, null: false
      t.bigint :volume

      t.timestamps
    end

    add_index :timeseries, :symbol
    add_index :timeseries, :ticker_date
    add_index :timeseries, [:symbol, :ticker_date], unique: true
  end
end
