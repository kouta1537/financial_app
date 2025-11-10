class CalculationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @calculation = Calculation.new(
    operating_profit: params[:operating_profit],
    depreciation: params[:depreciation],
    borrowing: params[:borrowing]
  )
  end

  def preview
    raw = params.require(:calculation).permit(:operating_profit, :depreciation, :borrowing)

    # --- 未入力チェック ---
    if raw[:operating_profit].blank? || raw[:depreciation].blank? || raw[:borrowing].blank?
      flash.now[:alert] = "すべての項目を入力してください（0はOKです）"
      @calculation = Calculation.new
      @calculation.operating_profit = raw[:operating_profit]
      @calculation.depreciation     = raw[:depreciation]
      @calculation.borrowing        = raw[:borrowing]
    
      return render :new, status: :unprocessable_entity
    end

    # --- 全項目入力あり → 数値変換して計算 ---
    op = raw[:operating_profit].delete(',').to_f
    dp = raw[:depreciation].delete(',').to_f
    br = raw[:borrowing].delete(',').to_f

    @cf = op + dp
    @debt_service_years = @cf > 0 ? (br / @cf).round(2) : nil

    # --- ビュー用に文字列を保持 ---
    @calculation = Calculation.new
    @calculation.operating_profit = raw[:operating_profit]
    @calculation.depreciation     = raw[:depreciation]
    @calculation.borrowing        = raw[:borrowing]

    render :result
  end

  def create
    @calculation = current_user.calculations.new(
      operating_profit: params[:calculation][:operating_profit].to_s.delete(',').to_f,
      depreciation:     params[:calculation][:depreciation].to_s.delete(',').to_f,
      borrowing:        params[:calculation][:borrowing].to_s.delete(',').to_f,
      operating_cf:     params[:calculation][:operating_cf].to_f,
      debt_service_years: params[:calculation][:debt_service_years].to_f
    )

    if @calculation.save
      redirect_to user_path(current_user), notice: "計算結果を保存しました"
    else
      render :new
    end
  end

  def destroy
  @calculation = current_user.calculations.find(params[:id])
  @calculation.destroy
  redirect_to user_path(current_user), notice: "計算結果を削除しました。"
  end

  private

  def calculation_params
    params.require(:calculation).permit(:operating_profit, :depreciation, :borrowing)
  end
end
