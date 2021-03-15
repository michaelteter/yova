class RenameDayTwrToDayReturn < ActiveRecord::Migration[5.2]
  def change
    rename_column :asset_performances, :day_twr, :day_return
  end
end
