module BxBlockUploadMedia
  class UploadPresigner

    def presign prefix, file_name

      ext_name = File.extname(file_name)
      file_name = "#{SecureRandom.uuid}#{ext_name}"
      upload_key = Pathname.new(prefix).join(file_name).to_s

      obj = S3_BUCKET.object(upload_key)

      params = { acl: 'public-read' }

      {
        presigned_url: obj.presigned_url(:put, params),
        public_url: obj.public_url
      }
    end

  end
end
