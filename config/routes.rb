Rails.application.routes.draw do
  get 'bots/new'
  get 'bots/create'
  get 'bots/edit'
  get 'bots/update'
  get 'bots/destroy'
  get 'bots/show'
  resources :bots

  get 'edus/show'
  get 'edus/index'
  get 'edus/backtest'
  get 'edus/stoptest'
  get 'edus/copybot'
  resources :edus

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  get 'bots/index'
  resources :bot_run

  resources :users, only: [:new, :create]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#logout'
  get 'welcome', to: 'sessions#welcome'



end