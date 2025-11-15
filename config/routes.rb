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

  get "index/users"

  get "new/users"
  post "create/users"

  get "login/users"
  post "login/users"

  delete "logout/users"

  get "edit_account/users"
  patch "edit_account/users"

  get "edit_profile/users"
  patch "edit_profile/users"

  patch "update_account/users"

  patch "update_profile/users"



  get "index/rooms"

  get "new/rooms"
  post "create/rooms"

  get "show/rooms"



  get "index/reservations"

  get "new/reservations"
  
  post "create/reservations"

  get "show/reservations"

  get "conf/reservations"
  post "conf/reservations"



  get "current_user/applications"

  get "search_address/applications"

  get "search_room_info/applications"
end
