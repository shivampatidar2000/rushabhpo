ActiveAdmin.register BxBlockCatalogue::Product ,as: "Product" do
     permit_params :name, :status, :category_id, :unique_id, images: [],
     product_details_attributes: [
      :id,
      :color_id,
      :price, 
      :shoe_size_id, 
      :description,
      :shoe_type_id,
      :template_length_id,
      :template_width_id,
      :arch_type_id,
      :_destroy,
    ]

    show do
      attributes_table title:"Product" do
        row :name
        row :images 
        row :category_id
        row "Images" do
          ul do
           product.images.each do |img|
             li do 
               image_tag(img, size: '100x100')
             end
           end
          end
        end
        row :created_at
        row :updated_at
    end
      panel "Product Detail" do
        table_for product.product_details do
          column :price
          column :color
          # column :size
          column :description
          column :shoe_size_id 
          column :shoe_type 
          column :template_length
          column :template_width_id
        end
      end
    end
  
    index do
      selectable_column
      id_column
      column :name
      column :state
      # column :gender
      column :status
      column :category_id
      column :unique_id
      column :price
      column :images
      column :description
      column :created_at
      actions
     
    end
  
      filter :name
      filter :state
      filter :gender
      filter :status
      filter :category_id
      filter :unique_id
      filter :price
      filter :description
      filter :created_at
    
    form do |f|
      f.inputs do
        f.input :name
        f.input :state, as: :select, collection: CS.states(:in).map{|key, value| value  }
        # f.input :gender
        f.input :status, as: :select, collection: %w(Deliverd Notdelivered)
        f.input :category_id, label: 'Category Id'
        f.input :unique_id, label: 'Unique Id'
        f.input :images, :as => :file, input_html: {multiple: true}
        # f.input :price
        # f.input :description
        f.has_many :product_details, allow_destroy: true do |pd|
          pd.input :price
          pd.input :description 
          pd.input :color_id, as: :select, collection: BxBlockProductProperties::Color.all.map{ |a| [a.color_name, a.id] }
          pd.input :shoe_size_id, as: :select, collection:  BxBlockProductProperties::ShoeSize.all.map{ |a| [a.shoe_size.to_s, a.id] }
          pd.input :arch_type_id, as: :select, collection:  BxBlockProductProperties::ArchType.all.map{ |a| [a.arch_type.to_s, a.id] }
          pd.input :shoe_type_id, as: :select, collection:  BxBlockProductProperties::ShoeType.all.map{ |a| [a.name.to_s, a.id] }
          pd.input :template_length_id, as: :select, collection:  BxBlockProductProperties::TemplateLength.all.map{ |a| [a.template_length.to_s, a.id] }
          pd.input :template_width_id, as: :select, collection: BxBlockProductProperties::TemplateWidth.all.map{ |a| [a.template_width.to_s, a.id] }
        end
        f.actions
    end
  end
end

  