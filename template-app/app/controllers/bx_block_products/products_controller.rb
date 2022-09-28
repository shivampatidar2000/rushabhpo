module BxBlockProducts
    class ProductsController < ApplicationController
      before_action :find_product, only: [:show, :update, :destroy]

        
    def index
        products = BxBlockCatalogue::Product.all.order(created_at: :desc)
        if products.present?
    products = products.page(params[:page] || 1).per(params["per_page"] || 10)
    render json: {products: ProductSerializer.new(products).serializable_hash, meta:{ pagination: SerializeHelper.pagination_dict(products)}} , status: :ok
        else
        render json: {data: []}, status: :ok
        end
    end

    # def show
    #     render json: ProductSerializer.new(@product).serializable_hash,status: :ok
    # end

    def show
        if @product.present?
          end
          render json: ProductSerializer.new(@product).serializable_hash, status: :ok
        else
          return render json: { message: 'Product not found' },status: :unprocessable_entity
        end
      end

    def create
        #  params[:data][:attributes][:account_id] = current_user.id
        @product = BxBlockCatalogue::Product.new(product_params)
        if @product.save
            render json: ProductSerializer.new(@product).serializable_hash,status: :ok
        else
            render json: @product.errors.messages.to_json, status: :unprocessable_entity
        end
    end
    def update
        if @product.update(product_params)
            render json: {message: "Product Successfully Updated"}, status: :ok
        else
            render json: {message: "Product not Update"}, status: :unprocessable_entity
        end 
    end
    
    
    def destroy
        if @product.destroy
            render json: {message: "Product Successfully Deleted"}, status: :ok
        else
            render json: {message: "Product not Delete"}, status: :unprocessable_entity
        end
    end
    

    private

    def find_product
        @product = BxBlockCatalogue::Product.find(params[:id]) rescue nil
        return render json: {message: "Product not found!"}, status: :unprocessable_entity if !@product
    end

    def product_params
        params.require(:data)[:attributes].permit(
            :id, :name,:state,:category_id,:unique_id,:price,:description, product_details_attributes: [
                :id,
                :name,
                :size,
                :color,
                :description,
                :_destroy
              ])
    end 

    # def product_detail_params
    #     params.require(:product).permit(
    #         :name,
    #       product_details_attributes: [
    #         :id,
    #         :name,
    #         :size,
    #         :color,
    #         :description,
    #         :_destroy
    #       ]
    #     )
    #   end
    
    end 
end