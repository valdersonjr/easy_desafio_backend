Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post '/user/sign_up' => 'users/registrations#create'
    put '/user/edit' => 'users/registrations#update'
    delete '/user/delete' => 'users/registrations#destroy'

    post '/user/sign_in' => 'users/sessions#create'
    delete '/user/sign_out' => 'users/sessions#destroy'
  end
end