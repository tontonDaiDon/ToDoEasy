Rails.application.routes.draw do
  resources :shopping_lists do
    resources :items, only: [:create, :destroy]
  end
end
