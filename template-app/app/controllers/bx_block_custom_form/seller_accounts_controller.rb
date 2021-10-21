module BxBlockCustomForm
  class SellerAccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    skip_before_action :validate_json_web_token, :only => [:index]

    def index
      if params[:search_term].present?
        @seller = SellerAccount.where(
          "firm_name LIKE ?", "%#{params[:search_term]}%"
        )
        render json: {seller: @seller, full_messages: "Successfully Loaded"}
      elsif params[:lat].present? && params[:long].present?
        @seller_whole = SellerAccount.within(
          2,
          :units => :kms,
          :origin => "#{params[:lat]}, #{params[:long]}"
        )
        @seller_retail = SellerAccount.within(
          2,
          :units => :kms,
          :origin => "#{params[:lat]}, #{params[:long]}"
        )
        render json: {
          seller_whole: @seller_whole,
          seller_retail: @seller_retail,
          message: "Successfully Loaded"
        }
      else
        @seller = SellerAccount.all
        render json: {seller: @seller, full_messages: "Successfully Loaded"}
      end
    end

    def create
      @seller_account = SellerAccount.new(
        seller_account_params.merge( { account_id: current_user.id} )
      )
      if @seller_account.save
        render json: SellerAccountSerializer.new(@seller_account
        ).serializable_hash, status: :created
      else
        render json: {
          errors: format_activerecord_errors(@seller_account.errors)
        }, status: :unprocessable_entity
      end
    end

    def show
      seller_account = SellerAccount.find_by(account_id: current_user.id)
      render json: SellerAccountSerializer.new(seller_account).as_json
    end

    def update
      seller_account = SellerAccount.find_by(account_id: current_user.id)
      if seller_account.update(seller_account_params)
        serializer = SellerAccountSerializer.new(seller_account)
        render :json => serializer.as_json,
               :status => :ok
      else
        render :json => {:errors => seller_account.errors.full_messages},
               :status => status
      end
    end

    private

    def seller_account_params
      params.require(:seller_account).permit(:firm_name,
                                             :full_phone_number,
                                             :location,
                                             :country_code,
                                             :phone_number,
                                             :gstin_number,
                                             :wholesaler,
                                             :retailer,
                                             :manufacturer,
                                             :hallmarking_center,
                                             :buy_gold,
                                             :buy_silver,
                                             :sell_gold,
                                             :sell_silver,
                                             :activated,
                                             :lat,
                                             :long)
    end
  end
end
