ActiveAdmin.register BxBlockProductProperties::TemplateWidth, as:"TemplateWidth" do
    menu parent: 'Product Properties', label: "Template Widths"
    permit_params :template_width
    
    index do
      selectable_column
      id_column
      column :template_width
      column :age_type
      actions
    end
  
    show do
      attributes_table do
        row :template_width
        row :age_type
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :template_width
        # f.input :age_type, collection: ["adult", "child"]
      end
      f.actions
    end
end

  