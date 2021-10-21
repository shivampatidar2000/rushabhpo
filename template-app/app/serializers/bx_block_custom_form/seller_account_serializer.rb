module BxBlockCustomForm
  class SellerAccountSerializer < BuilderBase::BaseSerializer
    attributes *[
        # :activated,
        :firm_name,
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
    ]
  end
end
