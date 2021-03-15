class CreatePortfolioPerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolio_performances do |t|
      t.references :portfolio, foreign_key: true
      t.numeric :twr_calendar_month
      t.numeric :twr_30_days
      t.date :period_end, null: false
      t.jsonb :assets_data, null: false, default: '{}'

      t.timestamps
    end

    add_index :portfolio_performances, [:portfolio_id, :period_end], unique: true
  end
end
