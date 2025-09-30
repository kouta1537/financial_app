class CreateCalculations < ActiveRecord::Migration[7.1]
  def change
    create_table :calculations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :operating_profit
      t.integer :depreciation
      t.integer :borrowing
      t.integer :operating_cf
      t.float :debt_service_years

      t.timestamps
    end
  end
end
