class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:reset_password]

  def reset_password
    user = User.find_by(email: "test@user")
    if user
      user.password = "testuser"
      user.password_confirmation = "testuser"
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
