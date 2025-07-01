Rails.application.routes.draw do
  resources :shopping_lists do
    member do
      get :before_shopping   # 買い物前
      get :during_shopping   # 買い物中
      get :after_shopping    # 買い物後
      patch :update_items    # 買い物中の一括更新
      get :discount_calc
      post :discount_calc
    end
    resources :items, only: [:create, :destroy, :edit, :update]
  end
  resources :purchase_histories, only: [:index, :show]
end
