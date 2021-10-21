module BxBlockCatalogue
  class Tag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :tags

    has_and_belongs_to_many :catalogue, join_table: :catalogues_tags
  end
end
