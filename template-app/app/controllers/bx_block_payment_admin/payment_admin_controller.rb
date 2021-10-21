module BxBlockPaymentAdmin
  class PaymentAdminController < ApplicationController
    def index
      if params[:type] == "credit"
      @payments  = BxBlockPaymentAdmin::PaymentAdmin.where("account_id = ?", @token.id )
      end
      if params[:type] == "debit"
        @payments  = BxBlockPaymentAdmin::PaymentAdmin.where("current_user_id = ?", @token.id )
      end
      return render json: {data: @payments} , status: :ok
    end

    def show
      @payments  = BxBlockPaymentAdmin::PaymentAdmin.find(params[:id])
      return render json: {data: @payments} , status: :ok
    end
  end
end
