class AddCompanyToTimeseries < ActiveRecord::Migration[5.2]
  def change
    add_reference :timeseries, :company, null: false, foreign_key: true

    add_index :timeseries, [:company_id, :ticker_date], unique: true
  end
end
