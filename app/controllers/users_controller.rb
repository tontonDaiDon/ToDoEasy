class UsersController < ApplicationController
    def reset_password
      user = User.find_by(email: "test@user")   # ←自分のメールに変更
      if user
        user.password = "testuser"              # ←好きなパスワード
        user.password_confirmation = "testuser"
        user.save!
        render plain: "✅ パスワードをリセットしました"
      else
        render plain: "❌ ユーザーが見つかりません"
      end
    end
  end
  