module BxBlockPosts
  class Update
    def initialize(post, post_attributes)
      @post = post
      @post_attributes = post_attributes
    end

    def execute
      image_attributes = @post_attributes.delete('image')
      if image_attributes
        decoded_data = Base64.decode64(image_attributes['data'])
        image_attributes['io'] = StringIO.new(decoded_data)
        @post.image = {
            io: image_attributes['io'],
            content_type: image_attributes['content_type'],
            filename: image_attributes['filename']
        }
      end
      @post.assign_attributes(@post_attributes)
      @post.save
      @post
    end
  end
end
