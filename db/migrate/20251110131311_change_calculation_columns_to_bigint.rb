class ChangeCalculationColumnsToBigint < ActiveRecord::Migration[7.1]
  def change
    change_column :calculations, :operating_profit, :bigint
    change_column :calculations, :depreciation, :bigint
    change_column :calculations, :borrowing, :bigint
    change_column :calculations, :operating_cf, :bigint
  end
end

