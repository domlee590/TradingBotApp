Rails.application.routes.draw do
  get 'bots/new'
  get 'bots/create'
  get 'bots/edit'
  get 'bots/update'
  get 'bots/destroy'
  get 'bots/show'
  resources :bots

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

end