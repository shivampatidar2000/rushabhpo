module BxBlockOrderManagement
  class AddAddressToOrder

    attr_accessor :params, :user, :order, :delivery_address, :billing_address

    def initialize(params, user)
      @params = params
      @user = user
      @order = Order.find_by(account_id: @user.id, id: params[:order_id])
    end

    def call
      if params.present?
        set_delivery_address
        if is_address_correct? && delivery_address.save
          DeliveryAddress.rest_addresses(delivery_address.id).where(
            account_id: user.id
          ).update_all(is_default: false) if delivery_address.is_default

          delivery_address_ids = order.delivery_addresses.where(
            address_for: delivery_address.address_for
          ).pluck(:id)

          if delivery_address_ids.present?
            order.delivery_address_orders.address_ids(delivery_address_ids).destroy_all
          end

          if order.delivery_addresses.where(id: delivery_address.id).blank?
            order.delivery_addresses << delivery_address
          end
          if billing_address.present? && billing_address.save

            DeliveryAddress.rest_addresses(billing_address.id).where(
              account_id: user.id
            ).update_all(is_default: false) if billing_address.is_default

            billing_address_ids = order.delivery_addresses.where(
              address_for: billing_address.address_for
            ).pluck(:id)

            order.delivery_address_orders.address_ids(
              billing_address_ids
            ).destroy_all if delivery_address_ids.present?

            order.delivery_addresses << billing_address
          end

          return OpenStruct.new(
            success?: true,
            data: {},
            msg: 'Address added successfully',
            code: 200
          )
        else
          return OpenStruct.new(
            success?: false,
            data: nil,
            msg: "Ooops, Sorry it seems like your address doesn't cover store's delivery area. " \
                 "Try again with valid address",
            code: 404
          )
        end
      else
        return OpenStruct.new(
          success?: false,
          data: nil,
          msg: "Ooops, Sorry it seems like you didn't provide the delivery address.",
          code: 404
        )
      end
    end

    private

    def is_address_correct?
      delivery_address.present? ? true : false
    end

    def address_params
      params.require(:address).permit(
        :name, :flat_no, :address, :address_line_2, :zip_code, :phone_number, :is_default,
        :state, :country, :city, :landmark
      )
    end

    def billing_params
      params.require(:address).require(:billing_address).permit(
        :name, :flat_no, :address, :address_line_2, :zip_code, :phone_number, :is_default,
        :state, :country, :city, :landmark
      )
    end

    def set_delivery_address
      @delivery_address = params[:delivery_address_id] ?
        DeliveryAddress.find_by(account_id: user.id, id: params[:delivery_address_id]) :
        DeliveryAddress.new(address_params.merge({ account_id: user.id }))
      @delivery_address.is_default = true if DeliveryAddress.find_by(account_id: user.id).blank?
      if params[:billing_same_as_shipping]
        order.delivery_address_orders.destroy_all
        @delivery_address.address_for = "billing and shipping"
      elsif params[:address][:billing_address].present?
        shipping_and_billing_ids = order.delivery_addresses.billing_and_shipping.pluck(:id)
        order.delivery_address_orders.address_ids(shipping_and_billing_ids).destroy_all
        @delivery_address.address_for = "shipping"
        @billing_address = DeliveryAddress.new(billing_params.merge({ account_id: user.id }))
        @billing_address.is_default = true if DeliveryAddress.find_by(account_id: user.id).blank?
        @billing_address.address_for = "billing"
      end
    end

  end
end
