class CalculationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @calculation = Calculation.new
  end

  def preview
    @calculation = Calculation.new(calculation_params)

    operating_profit = params[:calculation][:operating_profit].delete(',').to_f
    depreciation     = params[:calculation][:depreciation].delete(',').to_f
    borrowing        = params[:calculation][:borrowing].delete(',').to_f

    @cf = @calculation.operating_profit.to_f + @calculation.depreciation.to_f
    @debt_service_years = @cf > 0 ? (@calculation.borrowing.to_f / @cf).round(2) : nil

    @calculation = Calculation.new(
      operating_profit: operating_profit,
      depreciation: depreciation,
      borrowing: borrowing
    )

    render :result
  end

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
          .transform_values { |v| v.delete(',').to_f }
  end
end

