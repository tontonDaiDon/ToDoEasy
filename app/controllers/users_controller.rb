class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:reset_password]

  def reset_password
    user = User.find_by(email: "tarotaro@com")
    if user
      user.password = "newpassword"
      user.password_confirmation = "newpassword"
      if user.save(validate: false)
        render plain: "✅ パスワードをリセットしました"
      else
        render plain: "❌ 保存失敗: #{user.errors.full_messages.join(', ')}"
      end
    else
      render plain: "❌ ユーザーが見つかりません"
    end
  end
end
