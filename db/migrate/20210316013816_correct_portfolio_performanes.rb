class CorrectPortfolioPerformanes < ActiveRecord::Migration[5.2]
  def change
    tbl = :portfolio_performances
    remove_index tbl, column: [:portfolio_id, :period_end]
    remove_index tbl, column: :portfolio_id
    remove_foreign_key tbl, column: :portfolio_id
    remove_column tbl, :portfolio_id
    add_reference tbl, :client, foreign_key: true
    add_index tbl, [:client_id, :period_end], unique: true
  end
end
