module BxBlockPosts
  class Post < BxBlockPosts::ApplicationRecord
    self.table_name = :posts

    include Validators
    IMAGE_CONTENT_TYPES = %w(image/jpg image/jpeg image/png)

    has_many_attached :images, dependent: :destroy

    belongs_to :category,
               class_name: 'BxBlockCategories::Category'

    belongs_to :sub_category,
               class_name: 'BxBlockCategories::SubCategory',
               foreign_key: :sub_category_id, optional: true

    belongs_to :account, class_name: 'AccountBlock::Account'
    has_many_attached :media, dependent: :destroy

    validates_presence_of :body
    validates :media, blob: {
      content_type: IMAGE_CONTENT_TYPES,
      size_range: 1..3.megabytes
    }

    def media_url
      media_arr = Array.new
      media.each do |m|
        media_hash = Hash.new
        media_hash['url'] = m.service_url(expires_in: Rails.application.config.active_storage.service_urls_expire_in)
        media_hash['content_type'] = m.content_type
        media_arr << media_hash
      end
      media_arr
    end

    def upload_post_images(images_params)
      images_to_attach = []

      images_params.each do |image_data|
        if image_data[:data]
          decoded_data = Base64.decode64(image_data[:data].split(',')[1])
          images_to_attach.push(
            io: StringIO.new(decoded_data),
            content_type: image_data[:content_type],
            filename: image_data[:filename]
          )
        end
      end
      self.images.attach(images_to_attach) if images_to_attach.size.positive?
    end
  end
end
