class CreatePortfolios < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolios do |t|
      t.references :client, foreign_key: true, null: false
      t.references :company, foreign_key: true, null: false
      t.decimal :weight, precision: 12, scale: 4

      t.timestamps
    end

    add_index :portfolios, [:client_id, :company_id], unique: true
  end
end
