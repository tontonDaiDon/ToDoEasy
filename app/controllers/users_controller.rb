class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:reset_password]

  def reset_password
    # 本番 DB に存在するメールアドレスに置き換えてください
    user = User.find_by(email: "test@user")  

    if user
      # 新しいパスワードに置き換える
      user.password = "testuser"
      user.password_confirmation = "testuser"

      # バリデーションをスキップして保存（自動ログインも回避）
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
