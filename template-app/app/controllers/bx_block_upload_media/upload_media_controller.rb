module BxBlockUploadMedia
  class UploadMediaController < ApplicationController

    def create
      urls =[]
      begin
        params[:media][:meta].each do |media_meta|
          upload = BxBlockUploadMedia::Media.create!(
            imageable_type: params[:media][:imageable_type],
            imageable_id: params[:media][:imageable_id],
            file_name: media_meta[:file_name],
            file_size: media_meta[:file_size],
            category: media_meta[:category],
            status: 'pending'
          )
          url = BxBlockUploadMedia::UploadPresigner.new.presign(
            "users/1/seller_account/#{upload.category}/#{upload.id}",
            media_meta[:file_name]
          )
          urls << {
            id: upload.id,
            presigned_url: url[:presigned_url],
            public_url: url[:public_url],
            is_visiting: upload.category == 'visiting_card'
          }
        end
        render json: {data: urls}
      rescue Exception => e
        render json: OpenStruct.new(success?: false, errors: e)
      end
    end

    def bulk_upload
      begin
        params[:media].each do |m|
          media = BxBlockUploadMedia::Media.find_by(id: m[:id])
          media.update(status: m[:status], presigned_url: m[:presigned_url])
        end
        render json: {status: :ok, message: "Successfully Updated"}
      rescue Exception => e
        render json: OpenStruct.new(success?: false, errors: e)
      end
    end

    def index
      seller_account = BxBlockCustomForm::SellerAccount.find_by_account_id(current_user.id)

      visiting_card = BxBlockUploadMedia::Media.where(
        imageable_id: seller_account.id,
        imageable_type: 'BxBlockCustomForm::SellerAccount', category: 'visiting_card'
      )
      photo_gallery = BxBlockUploadMedia::Media.where(
        imageable_id: seller_account.id,
        imageable_type: 'BxBlockCustomForm::SellerAccount',
        category: 'photo_gallery'
      )
      render json: {visiting_card: visiting_card, photo_gallery: photo_gallery}
    end

    def upload_banner
      upload = BxBlockUploadMedia::Media.create!(
        imageable_type: banner_params[:imageable_type],
        imageable_id: banner_params[:imageable_id],
        file_name: banner_params[:file_name],
        file_size: banner_params[:file_size],
        category: banner_params[:category],
        status: 'pending'
      )
      resp = BxBlockUploadMedia::UploadPresigner.new.presign(
        "users/1/advertise_banner/#{upload.id}",
        banner_params[:file_name]
      )
      render json: {
        id: upload.id, presigned_url: resp[:presigned_url], public_url: resp[:public_url]
      }
    end

    def fetch_advertise_banner
      banners = BxBlockUploadMedia::Media.where(
        imageable_id: params[:id],
        imageable_type: 'BxBlockCustomAds::Advertisement'
      )
      render json: {banners: banners}
    end

    def banner_params
      params.require(:media).permit(:imageable_type, :imageable_id, :file_name, :file_size)
    end

  end
end
