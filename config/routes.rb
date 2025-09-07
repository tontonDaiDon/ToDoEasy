Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root "home#index"
  get 'home/index'
  resources :shopping_lists do
    member do
      get :before_shopping   # 買い物前
      get :during_shopping   # 買い物中
      get :after_shopping    # 買い物後
      patch :update_items    # 買い物中の一括更新
      get :discount_calc
      post :discount_calc
    end
    resources :items, only: [:new, :create, :edit, :update, :destroy]
    resources :purchase_histories, only: [:new, :create, :edit, :update]
  end
  resources :purchase_histories, only: [:index, :show]
  get '/logout', to: 'sessions#destroy', as: :simple_logout

  get "reset_password", to: "users#reset_password"

end