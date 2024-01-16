require 'rails_helper'

RSpec.describe "Sessions", type: :request do
	let(:user) { create(:user, profile: 'client') }

	describe 'POST /user/sign_in' do
		context 'when user exists' do
			it 'returns ok status' do
				post '/user/sign_in', params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }
				expect(response).to have_http_status(:ok)
			end

			it 'has jwt token in the header response' do
				post '/user/sign_in', params: { user: { email: user.email, password: user.password, password_confirmation: user.password } }
				expect(response.headers['Authorization']).to be_present
			end
		end

		context 'when user does not exist' do
			it 'returns unauthorized status' do
				post '/user/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(response).to have_http_status(:unauthorized)
			end

			it 'returns json with error message' do
				post '/user/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(response.body).to eq('Invalid Email or password.')
			end

			it 'does not have jwt token in the header response' do
				post '/user/sign_in', params: { user: { email: Faker::Internet.email, password: Faker::Internet.password, password_confirmation: Faker::Internet.password } }
				expect(response.headers['Authorization']).to be_blank
			end
		end
  end

	describe 'DELETE /user/sign_out' do
		context 'when user is logged in' do
			it 'returns ok status' do
				delete '/user/sign_out', headers: set_auth_headers(user)
				expect(response).to have_http_status(:ok)
			end

			# it 'removes the user token' do
			# 	delete '/user/sign_out', headers: set_auth_headers(user)
			# 	user.reload
			# end
		end

		context 'when user is not logged in' do
			it 'returns unauthorized status' do
				delete '/user/sign_out'
				expect(response).to have_http_status(:unauthorized)
			end
		end
	end
end