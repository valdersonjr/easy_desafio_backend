Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post '/users/sign_up' => 'users/registrations#create'
    put '/users/edit' => 'users/registrations#update'

    post '/users/sign_in' => 'users/sessions#create'
    delete '/users/sign_out' => 'users/sessions#destroy'
  end
end