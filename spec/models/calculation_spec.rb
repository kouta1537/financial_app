require 'rails_helper'

RSpec.describe Calculation, type: :model do
  let(:user) { create(:user) }

  describe 'callbacks' do
    it 'calculates operating_cf and debt_service_years before save' do
      calc = build(:calculation, user: user)
      calc.save
      expect(calc.operating_cf).to eq(1200.0)
      expect(calc.debt_service_years).to be_within(0.01).of(5000.0 / 1200.0)
    end

    it 'sets debt_service_years to nil when operating_cf is zero or negative' do
      calc = build(:calculation, user: user, operating_profit: -100, depreciation: -100, borrowing: 5000)
      calc.save
      expect(calc.operating_cf).to eq(-200)
      expect(calc.debt_service_years).to be_nil
    end
  end
end
