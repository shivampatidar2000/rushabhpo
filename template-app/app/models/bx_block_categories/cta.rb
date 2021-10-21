module BxBlockCategories
  class Cta < ApplicationRecord
    self.table_name = :cta

    belongs_to :category

    mount_uploader :long_background_image, ImageUploader
    mount_uploader :square_background_image, ImageUploader

    enum text_alignment: ["centre", "left", "right"]
    enum button_alignment: ["centre", "left", "right"], _suffix: true

    validates :headline, :text_alignment, presence: true, if: -> { self.is_text_cta }
    validates :button_text, :redirect_url, :button_alignment, presence: true,
              if: -> { self.has_button }

    def name
      headline
    end
  end
end
