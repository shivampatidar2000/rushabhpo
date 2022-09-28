ActiveAdmin.register BxBlockProductProperties::ArchType, as:"ArchType" do
    menu parent: 'Product Properties', label: "Arch Types"
    permit_params :arch_type
  
    index do
      selectable_column
      id_column
      column :arch_type
      actions
    end
  
    show do
      attributes_table do
        row :arch_type
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :arch_type
      end
      f.actions
    end
end