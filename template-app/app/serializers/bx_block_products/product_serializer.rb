module BxBlockProducts
    class ProductSerializer < BuilderBase::BaseSerializer
  
      attributes *[
          :id,
          :name,
          :state,
          :gender,
          :category_id,
          :unique_id,
          :created_at,
          :updated_at,
        #   :account
      ]
  
      attribute :account, if: Proc.new { |rec, params| params[:user].present? }
      
      attribute :product_details do |object, params|
        BxBlockProducts::ProductDetailSerializer.new(object.product_details).serializable_hash  
      end
  
    end
  end
  