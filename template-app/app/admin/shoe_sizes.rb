ActiveAdmin.register BxBlockProductProperties::ShoeSize, as:"ShoeSize" do
    menu parent: 'Product Properties', label: "Shoe Sizes"
    permit_params :shoe_size
    
    index do
      selectable_column
      id_column
      column :shoe_size
      actions
    end
  
    show do
      attributes_table do
        row :shoe_size #size_type
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :shoe_size
      end
      f.actions
    end
end