ActiveAdmin.register BxBlockProductProperties::Color, as:"Color" do
    menu parent: 'Product Properties', label: "Colors"
    permit_params :color_name, :color_code
  
    index do
      selectable_column
      id_column
      column :color_name
      column :color_code
      actions
    end
  
    show do
      attributes_table do
        row :color_name
        row :color_code
        row :created_at
        row :updated_at
      end
    end
  
    form do |f|
      f.inputs do
        f.input :color_name, as: :string
        f.input :color_code, input_html: { class: 'colorpicker' }
      end
      f.actions
    end
end