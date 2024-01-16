require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  let(:user) { create(:user, profile: 'client') }
  let(:different_user) { create(:user, profile: 'client') }
  let(:admin_user) { create(:user, profile: 'admin') }
  
  describe 'POST /user/sign_up' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post '/user/sign_up', params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:ok)
      end

      it 'returns ok status' do
        post '/user/sign_up', params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'returns unprocessable entity status' do
        post '/user/sign_up', params: { user: { email: '', password: '', password_confirmation: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'it returns email is invalid error' do
        post '/user/sign_up', params: { user: { email: 'auwdhuawd', password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
        expect(body_json(response)['errors'][0]).to eq('Email is invalid')
      end

      it 'it returns password confirmation cannot be blank' do
        post '/user/sign_up', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password } }
        expect(body_json(response)['errors'][0]).to eq("Password confirmation can't be blank")
      end
    end
  end

  describe 'PUT /user/edit' do

    context 'when user is an admin' do
      before do
        set_auth_headers(admin_user)  
      end

      context 'with valid params' do
        it 'updates itself' do
          put '/user/edit', params: { user: admin_user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
          admin_user.reload
          expect(response).to have_http_status(:ok)
          expect(admin_user.name).to eq('New Name')
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable entity status' do
          put '/user/edit', params: { user: { email: '', password: '', password_confirmation: '' } }, headers: @auth_headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'it returns email is invalid error' do
          put '/user/edit', params: { user: { email: 'auwdhuawd', password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }, headers: @auth_headers
          expect(body_json(response)['errors'][0]).to eq('Email is invalid')
        end

        it 'it returns password confirmation cannot be blank' do
          put '/user/edit', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password } }, headers: @auth_headers
          expect(body_json(response)['errors'][0]).to eq("Password confirmation can't be blank")
        end
      end
    end
  end

  describe 'PUT /user/edit/:id' do
    context 'when user is an admin' do

      before do
        set_auth_headers(admin_user)  
      end

      context 'with valid params' do
        it 'updates the passed id user' do
          put "/user/edit/#{user.id}", params: { user: user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
          user.reload
          expect(response).to have_http_status(:ok)
          expect(user.name).to eq('New Name')
        end
      end
    end

    context 'when user is not an admin' do
      before do
        set_auth_headers(user)
      end

      context 'with valid params' do

        #if passed if different from current user, it will update the current_user anyways
        it 'updates itself' do
          put "/user/edit/#{different_user.id}", params: { user: user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
          user.reload
          expect(response).to have_http_status(:ok)
          expect(user.name).to eq('New Name')
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable entity status' do
          put "/user/edit", params: { user: user.attributes.merge({ password: '123123', password_confirmation: '123123', profile: 'admin' }) }, headers: @auth_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE /user/delete' do
    context 'with valid params' do
      it 'deletes itself' do
        set_auth_headers(user)
        expect {
          delete '/user/delete', headers: @auth_headers
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end    
  end
end

# Talvez não seja certo chamar o endpoint de sign in aqui apenas para gerar o token
# Deve ter como gerar o token de outra forma
def set_auth_headers(user)
  post '/user/sign_in', params: { user: { email: user.email, password: user.password } }
  headers = response.headers
  @auth_headers = {
    'authorization' => headers['Authorization'],
  }
end