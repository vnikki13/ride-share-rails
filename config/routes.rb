Rails.application.routes.draw do
  root 'trips#index'
  resources :trips
  resources :passengers
  resources :drivers
end