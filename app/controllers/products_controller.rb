class ProductsController < ApplicationController
    before_action :authenticate_user!

    def index
        @products = Product.all
        if @products.any?
            render json: ProductSerializer.new(@products).serializable_hash
        else
            render json: { message: 'There is no existing product' }, status: :ok
        end
    end

    def show
        @product = Product.find_by(id: params[:id])
        
        if @product
            render json: ProductSerializer.new(@product).serializable_hash
        else
            render json: { error: 'Product not found' }, status: :not_found
        end
    end

    def create
        @product = Product.new
        @product.attributes = product_params
        save_product!
    end

    def update
        @product = Product.find_by(id: params[:id])

        if @product
            @product.update(product_params)
            render json: ProductSerializer.new(@product).serializable_hash
        else
            render json: { error: 'Product not found' }, status: :not_found
        end
    rescue
        render_error(fields: @product.errors.messages)
    end

    def destroy
        @product = Product.find_by(id: params[:id])
      
        if @product
          @product.destroy
          render json: { message: 'Product successfully deleted' }, status: :ok
        else
          render json: { error: 'Product not found' }, status: :not_found
        end
    rescue
        render_error(fields: @product.errors.messages)
    end

    private

    def product_params
        return {} unless params.has_key?(:product)
        params.require(:product).permit(:name, :ballast)
    end

    def save_product! 
        @product.save!
        render json: ProductSerializer.new(@product).serializable_hash
    rescue
        render_error(fields: @product.errors.messages)
    end
end
