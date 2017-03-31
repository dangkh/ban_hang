Rails.application.routes.draw do

  get "/home", to: "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/index", to: "static_pages#index"
  root "static_pages#home"

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    match "/sessions/user", to: "devise/sessions#create", via: :post
  end
  resources :category, only: [:index, :show] do
    resources :products, only: [:index, :show]
  end
  resources :products do
    resources :comments
  end
  namespace :admin do
    resources :users
    resources :orders
    resources :categories do
      resources :products do
        collection{post :import}
      end
    end
    resources :statistics, only: [:index]
    resources :suggest_products
  end
  resources :sessions, only: [:index, :create, :update, :destroy]
  resources :view, only: [:index]
  namespace :users do
    resources :orders, only: [:index, :create, :show]
  end
  resources :ratings, only: [:create, :update]
  resources :suggestions
  get "*path", to: "static_pages#home"
end
