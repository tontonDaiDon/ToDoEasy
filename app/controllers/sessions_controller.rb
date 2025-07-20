class SessionsController < ApplicationController
  def destroy
    sign_out current_user if user_signed_in?
    redirect_to root_path, notice: "ログアウトしました"
  end
end 