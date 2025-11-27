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

  get "index/users",  to: "users#index"

  get  "new/users",    to: "users#new"
  post "create/users", to: "users#create"

  get  "login/users",  to: "users#login"
  post "login/users",  to: "users#login"

  delete "logout/users", to: "users#logout"

  get  "edit_account/users", to: "users#edit_account"
  patch "edit_account/users", to: "users#update_account"

  get  "edit_profile/users", to: "users#edit_profile"
  patch "edit_profile/users", to: "users#update_profile"




  get "index/rooms", to: "rooms#index"

  get "new/rooms", to: "rooms#new"
  post "create/rooms", to: "rooms#create"

  get "show/rooms", to: "rooms#show"



  get "index/reservations", to: "reservations#index"

  get "new/reservations", to: "reservations#new"
  
  post "create/reservations", to: "reservations#create"

  get "show/reservations", to: "reservations#show"

  get "conf/reservations", to: "reservations#conf"
  post "conf/reservations", to: "reservations#conf"



  get "current_user/applications"

  get "search_address/applications"

  get "search_room_info/applications"

  resources :reservations
end
