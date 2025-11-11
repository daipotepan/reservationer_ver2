Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "reservations#index"
  
  resources :users do
    collection do
      get "login"
      post "login"
      delete "logout"
      get "edit_account"
      patch "edit_account"

      get "edit_profile"
      patch "edit_profile"

      patch "update_account"

      patch "update_profile"
    end
  end

  resources :rooms

  resources :reservations do
    collection do
      post "conf"
    end
  end
end
