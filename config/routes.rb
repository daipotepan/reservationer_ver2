Rails.application.routes.draw do
  # GET /logout でトップページにリダイレクト（404防止・UX向上）
  get '/logout', to: redirect('/'), as: nil
  root "reservations#index"

  delete '/logout', to: 'users#logout', as: :logout


  resources :users do
    collection do
      get :login
      post :login

      get :edit_account
      patch :update_account
      get :edit_profile
      patch :update_profile
    end
  end

  resources :rooms do
    collection do
      get :mine
    end
  end
  get "search_address/applications", to: "applications#search_address", as: :search_address_applications
  get "search_room_info/applications", to: "applications#search_room_info", as: :search_room_info_applications


  resources :reservations do
    collection do
      get :conf
      post :conf
      get :mine
    end
  end
end
