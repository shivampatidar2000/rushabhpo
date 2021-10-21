module BxBlockUploadMedia
  class Media < ApplicationRecord
    self.table_name = :media
    belongs_to :imageable, polymorphic: true
    enum status: [:pending, :rejected, :approved]
  end
end
