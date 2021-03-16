class RemoveNullConstraintsOnAssetPerformances < ActiveRecord::Migration[5.2]
  def change
    %i[return_1_day return_30_days return_1_cal_mo return_mtd return_ytd].each do |col|
      change_column_null :asset_performances, col, true
    end
  end
end
