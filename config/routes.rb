Rails.application.routes.draw do
  get 'modify_bot/new'
  get 'modify_bot/edit'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

end