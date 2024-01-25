Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/validate_token' => 'users/sessions#validate_token', as: :validate_token
  end

  namespace :users do
    resources :users, path: '', only: [:index, :show]
  end

  resources :products
  resources :orders
end
