module BxBlockCustomAds
  class AdvertisementsController < ApplicationController

    def index
      advertisements = if params[:scope] == "pending"
                         Advertisement.pending
                       elsif params[:scope] == "rejected"
                         Advertisement.rejected
                       else
                         Advertisement.approved
                       end
      render json: {
        advertisements: advertisements,
        message: "Successfully loded"
      }
    end

    def create
      advertisement = Advertisement.new(advertisement_params)
      advertisement.seller_account_id =
          BxBlockCustomForm::SellerAccount.find_by(
            account_id: current_user.id
          ).id
      if advertisement.save
        render json: {
          advertisement: advertisement,
          message: "Successfully created"
        }, status: :created
      else
        render json: {
          errors: format_activerecord_errors(advertisement.errors)
        }, status: :unprocessable_entity
      end
    end

    def show
      advertisement = Advertisement.find_by(id: params[:id])
      if advertisement
        render json: {
          advertisement: advertisement,
          message: "Successfully loded"
        }
      else
        render json: { error: "Advertisement not found" }
      end

    end

    private

    def advertisement_params
      params.require(:advertisement).permit(
        :name, :description, :duration, :advertisement_for, :status, :banner
      )
    end
  end
end
