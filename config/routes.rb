Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/validate_session' => 'users/sessions#validate_session', as: :validate_session
    put '/users(/:id)' => 'users/registrations#update'
  end

  namespace :users do
    resources :users, path: '', only: [:index, :show]
  end

  resources :products
  resources :loads
end
