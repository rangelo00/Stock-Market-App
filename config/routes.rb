Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admin/sessions',
    registrations: 'admin/registrations'
  }
  devise_for :traders, controllers: {
    sessions: 'traders/sessions',
    registrations: 'traders/registrations'
  }
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :traders do    # Removed the 'only' restriction
      member do
        patch :approve
        patch :reject
      end
    end
    resources :transactions, only: [:index] #full transaction list
  end
  
  namespace :traders do
    get 'dashboard', to: 'dashboard#index'
    resources :stocks do
      member do
        post 'buy'
        post 'sell'
      end
    end
    resources :portfolios, only: [:index]
    resources :transactions, only: [:index]
  end

  authenticated :admin do
    root 'admin/dashboard#index'
  end

  authenticated :trader do
    root 'traders/dashboard#index', as: :trader_root
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "home#index"
end
