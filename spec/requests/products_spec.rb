require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user, profile: 'client') }
  let(:admin_user) { create(:user, profile: 'admin') }
  let(:product) { create(:product) }

  describe "GET /products" do
    before do
      set_auth_headers(user)
    end

    it 'returns http success' do
      create_list(:product, 1)
      get '/products', headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns not found status' do
      get '/products', headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a list of products' do
      create_list(:product, 10)
      get '/products', headers: @auth_headers
      expect(body_json(response)['products'].count).to eq(10)
    end
  end

  describe "GET /product/:id" do
    before do
      set_auth_headers(user)
    end

    it 'returns http success' do
      product = create(:product)
      get "/product/#{product.id}", headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns not found status' do
      get '/product/0', headers: @auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a product' do
      product = create(:product)
      get "/product/#{product.id}", headers: @auth_headers
      expect(body_json(response)['id'].to_i).to eq(product.id)
    end
  end

  describe "POST /product/add" do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http success' do
        post '/product/add', params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns a product' do
        post '/product/add', params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(body_json(response)['id'].to_i).to eq(Product.last.id)
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        post '/product/add', params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT /product/edit/:id" do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http success' do
        product = create(:product)
        put "/product/edit/#{product.id}", params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns a product' do
        product = create(:product)
        put "/product/edit/#{product.id}", params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(body_json(response)['id'].to_i).to eq(product.id)
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        product = create(:product)
        put "/product/edit/#{product.id}", params: { product: attributes_for(:product) }, headers: @auth_headers	
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /product/delete/:id" do
    context 'with admin user' do
      before do
        set_auth_headers(admin_user)
      end

      it 'returns http success' do
        product = create(:product)
        delete "/product/delete/#{product.id}", headers: @auth_headers	
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns a message' do
        product = create(:product)
        delete "/product/delete/#{product.id}", headers: @auth_headers	
        expect(body_json(response)['message']).to eq('Product successfully deleted')
      end
    end

    context 'with client user' do
      before do
        set_auth_headers(user)
      end

      it 'returns forbidden status' do
        product = create(:product)
        delete "/product/delete/#{product.id}", headers: @auth_headers	
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
