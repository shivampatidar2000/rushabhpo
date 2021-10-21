module BxBlockOrderManagement
  class AddressesSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :name,
        :flat_no,
        :address,
        :address_type,
        :address_line_2,
        :zip_code,
        :phone_number,
        :latitude,
        :longitude,
        :address_for,
        :is_default,
        :address_type,
        :city,
        :state,
        :country,
        :landmark,
        :created_at,
        :updated_at,
        :account
    ]

    attribute :account, if: Proc.new { |rec, params| params[:user].present? }

  end
end
