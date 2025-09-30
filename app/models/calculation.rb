class Calculation < ApplicationRecord
  belongs_to :user

  before_save :calculate_fields

  private

  def calculate_fields
    self.operating_cf = (operating_profit || 0) + (depreciation || 0)
    if operating_cf.to_f > 0
      self.debt_service_years = borrowing.to_f / operating_cf
    else
      self.debt_service_years = nil
    end
  end
end
