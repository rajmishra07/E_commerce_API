Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get '/member_details', to: 'members#index'

  namespace :api do
    namespace :v1 do
      resources :products 
      resources :cart_items
      resources :carts, only: [:show]
    end
  end
end
