Rails.application.routes.draw do
  root 'homepages#index'
  resources :trips, except: :index
  resources :passengers
  resources :drivers
end