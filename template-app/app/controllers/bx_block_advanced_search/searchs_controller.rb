module BxBlockAdvancedSearch
  class SearchsController < ApplicationController
    skip_before_action :validate_json_web_token, :only => [:filter, :sorting]
    SELLER_ATTRIBUTES = %w(buy_gold sell_gold buy_silver sell_silver)

    def filter
      search_attributes = {}
      SELLER_ATTRIBUTES.each do |search_term|
        if params[search_term].present?
          search_attributes[search_term] = params[search_term]
        end
      end
      unless search_attributes.empty?
        @sellers = BxBlockCustomForm::SellerAccount.where(search_attributes)
      else
        @sellers = BxBlockCustomForm::SellerAccount.all
      end

      render json: {sellers: @sellers, full_messages: "Successfully Loaded"}
    end

    def sorting
      if params[:search_term].in?( %w(ASC DESC) ) &&
         params[:search_term].in?(SELLER_ATTRIBUTES)
        @seller = BxBlockCustomForm::SellerAccount.all.order(
          "#{params[:search_term1]} #{params[:search_term]}"
        )
      else
        @seller = BxBlockCustomForm::SellerAccount.all
      end

      render json: { sellers: @seller, full_messages: "Successfully Loaded" }
    end
  end
end
