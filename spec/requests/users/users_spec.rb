require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, profile: 'client') }

  describe "GET /users" do
    context 'as an authenticated user' do
      before do
        set_auth_headers(user)
      end

      it 'returns a list of users' do
        get '/users', headers: @auth_headers
        expect(body_json(response).count).to eq(User.count + 1)
      end

      it 'returns success status' do
        get '/users', headers: @auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'as an unauthenticated user' do
      it 'returns unauthorized status' do
        get '/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
