Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  get '/member_details' => 'members#index'
  get '/favicon.ico', to: 'application#favicon'

  namespace :api do
    namespace :v1 do
      resources :products
      resources :cart_items
      resource :carts, only: :show
      resources :orders
    end
  end
end