ActiveAdmin.register BxBlockProductProperties::ShoeType, as:"ShoeType" do
    menu parent: 'Product Properties', label: "Shoe Types"
    permit_params :name
    
    index do
      selectable_column
      id_column
      column :name
      actions
    end
  
    show do
      attributes_table do
        row :name #size_type
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :name
      end
      f.actions
    end
end