module BxBlockCatalogue
  class CataloguesTag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogues_tags

    belongs_to :catalogue
    belongs_to :tag
  end
end
