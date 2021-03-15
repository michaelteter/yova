class AddFieldsToAssetPerformances < ActiveRecord::Migration[5.2]
  def change
    rename_column :asset_performances, :day_return, :return_1_day
    add_column :asset_performances, :return_30_days, :numeric
    add_column :asset_performances, :return_1_cal_mo, :numeric
    add_column :asset_performances, :return_mtd, :numeric
    add_column :asset_performances, :return_ytd, :numeric
  end
end
