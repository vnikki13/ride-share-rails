Rails.application.routes.draw do
  root 'homepages#index'
  resources :trips, except: :index
  resources :passengers do 
    resources :trips, only: [:index, :new]
  end
  resources :drivers do # Included resources for Driver Trips (Suely)
    resources :trips, only: [:index, :new]
  end
end