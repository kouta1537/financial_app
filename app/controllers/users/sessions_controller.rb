class Users::SessionsController < Devise::SessionsController
def guest_sign_in
  user = User.guest
  Rails.logger.debug "Guest user: #{user.inspect}"
  Rails.logger.debug "User valid? #{user.valid?}, errors: #{user.errors.full_messages}"
  sign_in user
  Rails.logger.debug "User signed in successfully"
  redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
end

end
