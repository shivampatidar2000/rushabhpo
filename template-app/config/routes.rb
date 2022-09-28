Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :account_block, default: {format: :json} do
    resources :accounts, only: %i(create show destroy update) do
    end
  end 
  
  namespace :bx_block_login do
    resources :logins, only: %i(create show destroy update)
  end

  namespace :bx_block_products do
    resources :products, only: %i(index create show destroy update)
  end
  namespace :bx_block_patient do
    resources :patients, only: %i(index create show destroy update)
    get '/user_patients', to: 'patients#user_patients'
  end


end
