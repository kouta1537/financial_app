require 'rails_helper'

RSpec.describe "Calculations", type: :system do
  include ActionView::Helpers::NumberHelper
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  it "ログインしてマイページにアクセスできる" do
    login_as(user)

    visit user_path(user)
    expect(page).to have_content user.username
    expect(page).to have_link '登録内容編集'
    expect(page).to have_content '計算結果履歴'
  end

  it "マイページに計算結果履歴が表示される" do
    login_as(user)

    create(:calculation, user: user, borrowing: 1000, operating_cf: 1200, debt_service_years: 2)
    create(:calculation, user: user, borrowing: 5000, operating_cf: 3000, debt_service_years: nil)

    visit user_path(user)

    user.calculations.each do |calc|
      expect(page).to have_content calc.created_at.strftime('%Y/%m/%d')
      expect(page).to have_content "#{number_with_delimiter(calc.borrowing)}円"
      expect(page).to have_content "#{number_with_delimiter(calc.operating_cf.to_i)}円"
      if calc.debt_service_years.is_a?(Numeric)
        expect(page).to have_content "#{calc.debt_service_years.round} 年"
      else
        expect(page).to have_content "算出不可"
      end
    end
  end

  it "計算スタートボタンをクリックすると新規計算ページに遷移する" do
    login_as(user)

    visit user_path(user)
    click_link "計算スタート"

    expect(current_path).to eq new_calculation_path
    expect(page).to have_content "経常利益"
    expect(page).to have_content "減価償却費"
    expect(page).to have_content "借入金"
  end

  it "計算フォームに入力し計算結果プレビューが表示される" do
    login_as(user)

    visit new_calculation_path

    fill_in "経常利益", with: '1000'
    fill_in "減価償却費", with: '200'
    fill_in "借入金", with: '2400'

    click_button "計算"

    expect(page).to have_content "計算結果"
    expect(page).to have_content "CF: 1,200円"
    expect(page).to have_content "償還年数: 2"
  end

  it "未ログイン状態でマイページにアクセスするとログインページにリダイレクトされる" do
    visit user_path(user)
    expect(current_path).to eq new_user_session_path
  end
end

