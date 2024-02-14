require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  let(:user) { create(:user, profile: 'client') }
  let(:different_user) { create(:user, profile: 'client') }
  let(:admin_user) { create(:user, profile: 'admin') }

  describe 'POST /users' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post '/users', params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it 'returns created status' do
        post '/users', params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      context 'returns unprocessable entity status' do
        it 'does not accept blank attributes' do
          post '/users', params: { user: { email: '', password: '', password_confirmation: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not accept non existing user' do
          post '/users', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password } }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not accept invalid email format' do
          post '/users', params: { user: { email: 'auwdhuawd', password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /user' do

    context 'when user is an admin' do
      before do
        set_auth_headers(admin_user)
      end

      context 'with valid params' do
        it 'updates itself' do
          put '/users', params: { user: admin_user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
          admin_user.reload
          expect(response).to have_http_status(:ok)
          expect(admin_user.name).to eq('New Name')
        end
      end

      context 'with invalid params' do
        context 'returns unprocessable entity status' do
          it 'does not accept blank attributes' do
            put '/users', params: { user: { email: '', password: '', password_confirmation: '' } }, headers: @auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'does not accept invalid email format' do
            put '/users', params: { user: { email: 'auwdhuawd', password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }, headers: @auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'does not accept blank password' do
            put '/users', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password } }, headers: @auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when user is an admin' do

      before do
        set_auth_headers(admin_user)
      end

      context 'with valid params' do
        it 'updates the passed id user' do
          put "/users/#{user.id}", params: { user: user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
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
        it 'It cannot update given user' do
          current_name = different_user.name
          put "/users/#{different_user.id}", params: { user: user.attributes.merge({ name: 'New Name', password: '123123', password_confirmation: '123123' }) }, headers: @auth_headers
          different_user.reload
          expect(response).to have_http_status(:unauthorized)
          expect(current_name).to eq(different_user.name)
        end
      end

      context 'with invalid params' do
        it 'returns unprocessable entity status' do
          put "/users", params: { user: user.attributes.merge({ password: '123123', password_confirmation: '123123', profile: 'admin' }) }, headers: @auth_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE /users' do
    context 'with valid params' do
      it 'deletes itself' do
        set_auth_headers(user)
        expect {
          delete '/users', headers: @auth_headers
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
