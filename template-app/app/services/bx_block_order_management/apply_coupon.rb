module BxBlockOrderManagement
  class ApplyCoupon
    attr_accessor :coupon_code, :cart_value, :order

    def initialize(order, coupon, params)
      @coupon_code  =   coupon
      @order        =   order
      @cart_value   =   params[:cart_value].to_f
    end

    def call
      discount = coupon_code.discount_type == "percentage" ?
                     ((cart_value * coupon_code.discount) / 100) :
                     coupon_code.discount
      discount_price = (cart_value - discount)&.round(2)
      order.update_attributes!(
        coupon_code_id: coupon_code.id,
        total: discount_price,
        applied_discount: discount
      )
    end
  end
end
