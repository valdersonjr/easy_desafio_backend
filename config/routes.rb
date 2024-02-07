Rails.application.routes.draw do
  defaults format: :json do

    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }

    devise_scope :user do
      get '/validate_session' => 'users/sessions#validate_session', as: :validate_session
      put '/users/:id' => 'users/registrations#update_user_by_id'
      delete '/users/:id' => 'users/registrations#destroy_user_by_id'
    end

    namespace :users do
      resources :users, path: '', only: [:index, :show]
    end

    resources :products
    resources :loads
    resources :counts, only: [:index]
  end
end
