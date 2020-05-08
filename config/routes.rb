Rails.application.routes.draw do
  root 'trip#index'
  resources :trip
  resources :passenger
  resources :driver
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :passengers
  resources :drivers
end