module BxBlockPosts
  class PostSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :name,
        :description,
        :body,
        :location,
        :account_id,
        :created_at,
        :updated_at
    ]

    attribute :model_name do |object|
      object.class.name
    end

    attribute :images_and_videos do |object|
      object.images.attached? ?
        object.images.map { |img|
          {
            id: img.id, filename: img.filename,
            url: Rails.application.routes.url_helpers.url_for(img),
            type: img.blob.content_type.split('/')[0]
          }
        } : []
    end

    attribute :media do |object|
      object.media_url
    end

    attribute :created_at do |object|
      "#{time_ago_in_words(object.created_at)} ago"
    end
  end
end
