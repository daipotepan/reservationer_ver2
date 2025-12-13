Rails.application.routes.draw do
  root "reservations#index"

  resources :users do
    collection do
      get :login
      post :login
      delete :logout
      get :edit_account
      patch :update_account
      get :edit_profile
      patch :update_profile
    end
  end

  resources :rooms
  get "search_address/applications", to: "applications#search_address", as: :search_address_applications
  get "search_room_info/applications", to: "applications#search_room_info", as: :search_room_info_applications


  resources :reservations do
    collection do
      get :conf
      post :conf
    end
  end
end
