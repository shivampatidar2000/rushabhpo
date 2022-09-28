module BxBlockProducts
    class ProductDetailSerializer < BuilderBase::BaseSerializer
  
      attributes *[
          :id,
          :name,
          :product_id,
          :price,
          :size,
          :color,
          :description, 
          :created_at,
          :updated_at,
        #   :account
      ]
  
    #   attribute :account, if: Proc.new { |rec, params| params[:user].present? }
    
  
    end
  end
  