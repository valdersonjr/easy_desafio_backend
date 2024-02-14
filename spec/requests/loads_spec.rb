require 'rails_helper'

RSpec.describe "Load", type: :request do
  let(:user) { create(:user, profile: 'client') }
  let(:admin_user) { create(:user, profile: 'admin') }
  let(:load) { create(:load) }

  describe 'GET /loads' do
    before do
      set_auth_headers(user)
    end

    it 'returns http success' do
      create_list(:load, 1)
      get '/loads', headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns not found status' do
      get '/loads', headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a list of loads' do
      create_list(:load, 10)
      get '/loads', headers: @auth_headers
      expect(body_json(response)['loads'].count).to eq(10)
    end
  end

  describe 'GET /loads/:id' do
    before do
      set_auth_headers(user)
    end

    it 'returns http success' do
      load = create(:load)
      get "/loads/#{load.id}", headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns not found status' do
      get '/loads/0', headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a load' do
      load = create(:load)
      get "/loads/#{load.id}", headers: @auth_headers
      expect(body_json(response)['load']['id'].to_i).to eq(load.id)
    end
  end

  describe 'POST /loads' do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http created' do
        post '/loads', params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(response).to have_http_status(:created)
      end

      it 'returns a load' do
        post '/loads', params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(body_json(response)['message']).to eq('Load created successfully')
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        load = build(:load)
        post '/loads', params: load.as_json, headers: @auth_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /loads/:id' do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http success' do
        load = create(:load)
        put "/loads/#{load.id}", params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns not found status' do
        put '/loads/0', params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a load' do
        load = create(:load)
        put "/loads/#{load.id}", params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(body_json(response)['message']).to eq('Load updated successfully')
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        load = create(:load)
        put "/loads/#{load.id}", params: { load: attributes_for(:load) }, headers: @auth_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /loads/:id' do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http success' do
        load = create(:load)
        delete "/loads/#{load.id}", headers: @auth_headers
        expect(response).to have_http_status(:ok)
      end

      it 'returns not found status' do
        delete '/loads/0', headers: @auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        load = create(:load)
        delete "/loads/#{load.id}", headers: @auth_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end
