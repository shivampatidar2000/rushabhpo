module BxBlockFedexIntegration
  class ShipmentsController < ApplicationController
    def create
      shipment_params = jsonapi_deserialize(params)
      shipment_service = ShipmentService.new
      response = shipment_service.create(shipment_params)

      if response['status'] == "PROPOSED"
        render json: response, status: :created
      else
        render json: response, status: :unprocessable_entity
      end
    end

    def show
      shipment_service = ShipmentService.new
      response = shipment_service.get(params[:id])

      if response.present?
        render json: response, status: :ok
      else
        render json: response, status: :not_found
      end
    end
  end
end
