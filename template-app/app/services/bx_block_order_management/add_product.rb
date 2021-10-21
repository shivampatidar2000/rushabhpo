module BxBlockOrderManagement
  class AddProduct
    attr_accessor :params, :quantity, :catalogue, :order, :user, :catalogue_variant

    def initialize(params, user)
      @params = params
      @quantity = params[:quantity]
      @catalogue_id = params[:catalogue_id]
      @catalogue = BxBlockCatalogue::Catalogue.find(@catalogue_id)
      @order = Order.find_by_id(params[:cart_id]) if params[:cart_id].present?
      @order = Order.create!(
        account_id: user.id,
        status: "created",
        coupon_code_id: params[:coupon_code_id]
      ) unless params[:cart_id].present?
      @catalogue_variant = @catalogue.catalogue_variants.find_by(id: params[:catalogue_variant_id])
      @user = user
    end

    def call
      if params[:catalogue_variant_id].present? && catalogue_variant.blank?
        return OpenStruct.new(
          success?: false,
          data: nil,
          msg: 'Sorry, Product Variant is not found for this product',
          code: 404
        )
      elsif product_not_available?
        return OpenStruct.new(
          success?: false,
          data: nil,
          msg: 'Sorry, Product is out of stock',
          code: 404
        )
      elsif order.blank?
        return OpenStruct.new(
          success?: false,
          data: nil,
          msg: 'Sorry, cart is not found',
          code: 404
        )
      else
        order.order_items.create!(order_item_params)
        msg = "Item added in cart successfully" if params[:cart_id].present?
        msg = "Order created successfully" unless params[:cart_id].present?
        return OpenStruct.new(success?: true, data: order, msg: msg, code: 200)
      end
    end

    private

    def product_not_available?
      if catalogue_variant.present?
        quantity.to_i > (@catalogue_variant.stock_qty.to_i - @catalogue_variant.block_qty.to_i || 0)
      else
        quantity.to_i > (@catalogue.stock_qty.to_i - @catalogue.block_qty.to_i || 0)
      end
    end

    def order_item_params
      params.permit(:quantity, :catalogue_id, :catalogue_variant_id)
    end

  end
end
