require 'rails_helper'

RSpec.describe CalculationsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "GET #new" do
    it "renders new template with status 200" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #preview" do
    context "without calculation params" do
      it "redirects to new_calculation_path with alert" do
        post :preview
        expect(response).to redirect_to(new_calculation_path)
        expect(flash[:alert]).to eq("計算フォームから送信してください")
      end
    end

    context "with blank inputs" do
      it "renders :new with alert and unprocessable_entity status" do
        post :preview, params: { calculation: { operating_profit: '', depreciation: '', borrowing: '' } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("すべての項目を入力してください（0はOKです）")
      end
    end

    context "with valid inputs" do
      it "renders :result template" do
        post :preview, params: { calculation: { operating_profit: '1000', depreciation: '200', borrowing: '2400' } }
        expect(response).to render_template(:result)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new calculation and redirects" do
        params = {
          calculation: {
            operating_profit: '1000',
            depreciation: '200',
            borrowing: '2400',
            operating_cf: 1200,
            debt_service_years: 2
          }
        }
        expect {
          post :create, params: params
        }.to change(Calculation, :count).by(1)
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq("計算結果を保存しました")
      end
    end

    context "with invalid params" do
      it "renders :new template" do
        allow_any_instance_of(Calculation).to receive(:save).and_return(false)
        post :create, params: {
          calculation: {
            operating_profit: '',
            depreciation: '',
            borrowing: '',
            operating_cf: 0,
            debt_service_years: 0
          }
        }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:calculation) { create(:calculation, user: user) }

    it "deletes the calculation and redirects" do
      expect {
        delete :destroy, params: { id: calculation.id }
      }.to change(Calculation, :count).by(-1)
      expect(response).to redirect_to(user_path(user))
      expect(flash[:notice]).to eq("計算結果を削除しました。")
    end
  end

  describe "authentication" do
    before { sign_out user }

    it "redirects unauthenticated user to login" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
      post :preview
      expect(response).to redirect_to(new_user_session_path)
      post :create
      expect(response).to redirect_to(new_user_session_path)
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
