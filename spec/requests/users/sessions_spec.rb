require 'rails_helper'

RSpec.describe "Sessions", type: :request do
	let(:user) { create(:user, profile: 'client') }

	describe 'POST /users/sign_in' do
		context 'when user exists' do
			it 'returns ok status' do
				post '/users/sign_in', params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }
				expect(response).to have_http_status(:created)
			end

			it 'has jwt token in the header response' do
				post '/users/sign_in', params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }
				expect(response.headers['Authorization']).to be_present
			end
		end

		context 'when user does not exist' do
			it 'returns unauthorized status' do
				post '/users/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(response).to have_http_status(:unauthorized)
			end

			it 'returns json with error message' do
				post '/users/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(body_json(response)['error']).to eq('Invalid Email or password.')
			end

			it 'does not have jwt token in the header response' do
				post '/users/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(response.headers['Authorization']).to be_blank
			end
		end
  end

	describe 'DELETE /users/sign_out' do
		context 'when user is logged in' do
			it 'returns ok status' do
				delete '/users/sign_out', headers: set_auth_headers(user)
				expect(response).to have_http_status(:ok)
			end
		end

		context 'when user is not logged in' do
			it 'returns unauthorized status' do
				delete '/user/sign_out'
				expect(response).to have_http_status(:not_found)
			end
		end
	end
end
