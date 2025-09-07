# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # ここでログイン不要にしておく
  skip_before_action :authenticate_user!, only: [:reset_password]

  # 一時的なパスワードリセット用アクション
  def reset_password
    # 変更したいユーザーのメールアドレスに置き換えてください
    user = User.find_by(email: "test@user")
    
    if user
      # 新しいパスワードに置き換える
      user.password = "testuser"
      user.password_confirmation = "testuser"
      
      # バリデーションは無視して保存（Devise の自動サインインも避けられる）
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
