#  ActiveAdmin.register BxBlockCatalogue::ProductDetail, as: "product detail" do
#     # menu label: "Product Detail" 
#     menu parent: "Product", label: "Product Detail"
#     permit_params :name, :gender, :product_id, :price, :description 
  
#     index do
#       selectable_column
#       id_column
#       column :name
#       column :product_id
#       column :price
#       column :color
#       column :size
#       column :description
#       column :created_at
#       actions
#     end
  
#     filter :name
#     filter :state
#     filter :product_id
#     filter :price
#     filter :color
#     filter :size
#     filter :description
#     filter :created_at
  
#     form do |f|
#       f.inputs do
#         f.input :name
#         f.input :product_id, label: 'Product Id'
#         f.input :price
#         f.input :description
#         f.input :color
    
       
#       end
#       f.actions
#     end
  
#   end
  