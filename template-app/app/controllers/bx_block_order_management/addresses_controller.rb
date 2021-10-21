module BxBlockOrderManagement
  class AddressesController < ApplicationController

    before_action :get_user, only: [:index, :create, :show, :destroy, :update]
    before_action :fetch_address, only: [:show, :destroy, :update]

    def index
      addresses = user_delivery_addresses
      render json: AddressesSerializer.new(addresses).serializable_hash,
             status: :ok
    end

    def create
      delivery_address = DeliveryAddress.new(
        address_params.merge({ account_id: @current_user.id })
      )
      delivery_address.is_default = true if user_delivery_addresses.blank?
      delivery_address.save!
      DeliveryAddress.rest_addresses(delivery_address.id).where(
        account_id: @current_user.id
      ).update_all(is_default: false) if delivery_address.is_default
      render json: AddressesSerializer.new(delivery_address, serialize_options).serializable_hash,
             message: 'Address added successfully ', status: :ok
    end

    def show
      render json: AddressesSerializer.new(@delivery_address, serialize_options).serializable_hash,
             status: :ok
    end

    def destroy
      @delivery_address.destroy
      render json: { message: 'Address deleted successfully' }, status: :ok
    end

    def update
      @delivery_address.update!(address_params)
      DeliveryAddress.rest_addresses(@delivery_address.id).where(
        account_id: @current_user.id
      ).update_all(is_default: false) if @delivery_address.is_default
      render json: AddressesSerializer.new(@delivery_address, serialize_options).serializable_hash,
             message: 'Address updated successfully ', status: :ok
    end

    private

    def user_delivery_addresses
      @user_delivery_addresses ||= DeliveryAddress.where(account_id: @current_user.id)
    end

    def address_params
      params.require(:address).permit(
        :name, :flat_no, :address_type, :address, :address_line_2, :zip_code, :phone_number,
        :latitude, :longitude, :is_default, :state, :country, :city, :landmark
      )
    end

    def fetch_address
      @delivery_address = DeliveryAddress.find_by(account_id: @current_user.id, id: params[:id])
    end

    def serialize_options
      { params: { user: @current_user } }
    end


  end
end
