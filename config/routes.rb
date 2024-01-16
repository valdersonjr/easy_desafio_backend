Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post '/user/sign_up' => 'users/registrations#create'
    put '/user/edit(/:id)' => 'users/registrations#update'
    delete '/user/delete' => 'users/registrations#destroy'

    post '/user/sign_in' => 'users/sessions#create'
    delete '/user/sign_out' => 'users/sessions#destroy'
  end

  get '/users' => 'users/users#index'
  get '/users/:id' => 'users/users#show'

  get '/products' => 'products#index'
  get '/product/:id' => 'products#show'
  post '/product/add' => 'products#create'
  put '/product/edit/:id' => 'products#update'
  delete '/product/delete/:id' => 'products#destroy'

  get '/loads' => 'loads#index'
  get '/load/:id' => 'loads#show'
  post '/load/add' => 'loads#create'
  put '/load/edit/:id' => 'loads#update'
  delete '/load/delete/:id' => 'loads#destroy'
end
