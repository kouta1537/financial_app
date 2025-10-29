class CalculationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @calculation = Calculation.new
  end

def preview
  @calculation = Calculation.new(calculation_params)
  @cf = @calculation.operating_profit.to_f + @calculation.depreciation.to_f
  @debt_service_years = @cf > 0 ? (@calculation.borrowing.to_f / @cf).round(2) : nil
  render :result
end


  # 実際に保存
  def create
    @calculation = current_user.calculations.new(calculation_params)
    if @calculation.save
      redirect_to mypage_path, notice: "計算結果を保存しました"
    else
      render :new
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:operating_profit, :depreciation, :borrowing)
  end
end
