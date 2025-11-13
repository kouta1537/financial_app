FactoryBot.define do
  factory :calculation do
    association :user
    operating_profit { 1000.0 }
    depreciation { 200.0 }
    borrowing { 5000.0 }
    operating_cf { 1200.0 }
    debt_service_years { 4.17 }
  end
end