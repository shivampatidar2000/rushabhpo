module BxBlockCategories
  class SubCategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at

    attribute :categories, if: Proc.new { |record, params|
      params && params[:categories] == true
    }
  end
end
