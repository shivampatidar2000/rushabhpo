module BxBlockCatalogue
  class BrandSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at
  end
end
