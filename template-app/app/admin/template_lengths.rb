ActiveAdmin.register BxBlockProductProperties::TemplateLength, as:"TemplateLength" do
    menu parent: 'Product Properties', label: "Template Lengths"
    permit_params :template_length
    
    index do
      selectable_column
      id_column
      column :template_length
      column :age_type
      actions
    end
  
    show do
      attributes_table do
        row :template_length
        row :age_type
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :template_length
        # f.input :age_type, collection: ["adult", "child"]
      end
      f.actions
    end
end

  