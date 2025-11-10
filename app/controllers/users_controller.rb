class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit_account, :update_account, :show_profile, :edit_profile, :update_profile]
  
  # アカウント表示ページ
  def show
    @user = User.find(params[:id])
    @calculations = @user.calculations || [] 
  end
  
  # プロフィール表示ページ
  def show_profile
  end
  
  # アカウント編集ページ
  def edit_account
  end
  
  # プロフィール編集ページ
  def edit_profile
    @user = current_user
  end
  
  # アカウント情報更新
  def update_account
    if @user.update(account_params)
      redirect_to show_account_user_path(@user), notice: 'アカウント情報が更新されました。'
    else
      render :edit_account
    end
  end
  
  # プロフィール情報更新
  def update_profile
    if @user.update(profile_params)
      redirect_to show_profile_user_path(@user), notice: 'プロフィールが更新されました。'
    else
      render :edit_profile
    end
  end
end

private

def set_user
  @user = User.find(params[:id])
end
