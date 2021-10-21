module BxBlockOrderManagement
  class OrdersController < ApplicationController

    before_action :check_order_item, only: [:show]
    before_action :check_order, only: [:update_payment_source]

    def my_orders
      orders = Order.includes(
        :coupon_code, order_items: [catalogue: %i[category sub_category brand]]
      ).where(
        account_id: @current_user.id
      ).where.not(
        status: ['in_cart','created']
      ).order(created_at: :desc)
      if orders.present?
        render json: OrderSerializer.new(orders, serializable_options), status: 200
      else
        render json: { message: 'No order record found.' }, status: 200
      end
    end

    def create
      @res = AddProduct.new(params, @current_user).call
      update_cart_total(@res.data) if @res.success?
      if @res.success? && !@res.data.nil?
        order = Order.includes(
          :coupon_code, order_items: [catalogue: %i[category sub_category brand]]
        ).find(@res.data.id)
        render json: {
          data:
            {
              coupon_message: @cart_response.nil? || @cart_response.success? ?
                                  nil : @cart_response.msg,
              order: OrderSerializer.new(
                order,
                {
                  params: {
                    user: @current_user,
                    host: request.protocol + request.host_with_port
                  }
                }
              )
            }
        }, status: "200"
      else
        render json: { errors: @res.msg }, status: @res.code
      end
    end

    def show
      if @order_item.order.account_id == @current_user.id
        render json: OrderItemSerializer.new(
          @order_item,
          { params: { order: true, host: request.protocol + request.host_with_port } }
        ).serializable_hash, status: :ok
      else
        render json: 'Order item not belongs to you', status: :unprocessable_entity
      end
    end


    def cancel_order
      order = Order.find_by({ account_id: @current_user.id, id: params[:order_id] })
      render json: { errors: ['Record not found'] }, status: 404 and return unless order.present?
      order_status_id = OrderStatus.find_or_create_by(
        status: 'cancelled', event_name: 'cancel_order'
      ).id
      unless order.in_cart?
        # if params[:item_id].present?
        order.order_items.map do |a| a.update(
          order_status_id: order_status_id, cancelled_at: Time.current)
        end
        order.update(
          order_status_id: order_status_id,
          status: 'cancelled',
          cancelled_at: Time.current
        ) if order.full_order_cancelled?
        # else
        # order.update_attributes!(order_status_id: order_status_id, status: "cancelled")
        # end
        render json: { message: 'Order cancelled successfully' },
               status: :ok
      else
        render json: { error: 'Your order is in cart. so no need to cancel it' },
               status: :unprocessable_entity
      end
    end

    def add_address_to_order
      x = AddAddressToOrder.new(params, @current_user).call
      if x.success?
        render json: { message: x.msg }, status: x.code
      else
        render json: { message: x.msg }, status: x.code
      end
    end

    def update_payment_source
      x = UpdatePayment.new(params, @order).call
      if x.success?
        render json: { message: x.msg }, status: x.code
      else
        render json: { message: x.msg }, status: x.code
      end
    end

    def apply_coupon
      @order = BxBlockOrderManagement::Order.where(
        account_id: @current_user.id
      ).in_cart.find(params[:cart_id])
      @coupon =  BxBlockCouponCg::CouponCode.find_by_code(params[:code])
      render(json: { message: "Invalid coupon" }, status: 400) && return if @coupon.nil?
      render(json: { message: "Can't find order" }, status: 400) && return if @order.nil?

      if @order.total < @coupon.min_cart_value
        render json: { message: "Keep shopping to apply the coupon" }, status: 400
      else
        ApplyCoupon.new(@order, @coupon, params).call
        render json: {
          data: {
            coupon: OrderSerializer.new(@order)
          }
        }, status: 200
      end
    end

    private

    def check_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def check_order
      @order = Order.find_by(account_id: @current_user.id, id: params[:order_id])
    end

    def update_cart_total(order)
      @cart_response = UpdateCartValue.new(order, @current_user).call
    end

    def serializable_options
      { params: { host: request.protocol + request.host_with_port } }
    end

  end
end
