class ChangePortfolioPerfCols < ActiveRecord::Migration[5.2]
  def change
    rename_column :portfolio_performances, :twr_calendar_month, :twr_1_cal_mo
    %i[twr_mtd twr_ytd twr_1_day].each do |col|
      add_column :portfolio_performances, col, :numeric
    end
    change_column_null :portfolio_performances, :twr_1_cal_mo, true
    change_column_null :portfolio_performances, :twr_30_days, true
  end
end
