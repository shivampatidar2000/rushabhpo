module BxBlockUploadMedia
  class UploadMediaSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    attributes :imageable_type, :imageable_id, :file_name, :file_size,
               :presigned_url, :status, :category
  end
end
