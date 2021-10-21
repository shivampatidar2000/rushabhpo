module BxBlockCategories
  class CategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :dark_icon, :dark_icon_active, :dark_icon_inactive, :light_icon,
               :light_icon_active, :light_icon_inactive, :rank, :created_at, :updated_at

    attribute :dark_icon do |object|
      object.dark_icon_url
    end

    attribute :dark_icon_active do |object|
      object.dark_icon_active_url
    end

    attribute :dark_icon_inactive do |object|
      object.dark_icon_inactive_url
    end

    attribute :light_icon do |object|
      object.light_icon_url
    end

    attribute :light_icon_active do |object|
      object.light_icon_active_url
    end

    attribute :light_icon_inactive do |object|
      object.light_icon_inactive_url
    end

    attribute :sub_categories, if: Proc.new { |record, params|
      params && params[:sub_categories] == true
    }

    attribute :selected_sub_categories do |object, params|
      if params[:selected_sub_categories].present?
        object.sub_categories.where(id: params[:selected_sub_categories])
      end
    end

  end
end
