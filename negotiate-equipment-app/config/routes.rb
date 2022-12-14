require 'sidekiq/web'

Rails.application.routes.draw do
  resources :products
  resources :vacations
  resources :users do
    get :choose_equipment
    post :change_equipment
  end

  namespace :api do
    namespace :v1 do
      resources :reports, only: [:index]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'
end
