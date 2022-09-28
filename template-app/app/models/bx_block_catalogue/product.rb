module BxBlockCatalogue
    class Product < BxBlockCatalogue::ApplicationRecord
      self.table_name = :products

      validates :unique_id, uniqueness: true, presence: true
      has_many_attached :images

      belongs_to :category,class_name: 'BxBlockCategories::Category'
      has_many :product_details, class_name: 'BxBlockCatalogue::ProductDetail'

      accepts_nested_attributes_for :product_details, allow_destroy: true
    end
  end
  