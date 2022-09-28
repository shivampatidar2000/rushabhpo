module BxBlockCatalogue
    class ProductDetail < BxBlockCatalogue::ApplicationRecord
      self.table_name = :products_details
      belongs_to :product,class_name: 'BxBlockCatalogue::Product'
      belongs_to :arch_type,class_name: 'BxBlockProductProperties::ArchType'
      belongs_to :color,class_name: 'BxBlockProductProperties::Color'
      belongs_to :template_length,class_name: 'BxBlockProductProperties::TemplateLength'
      belongs_to :template_width,class_name: 'BxBlockProductProperties::TemplateWidth'
      belongs_to :shoe_size,class_name: 'BxBlockProductProperties::ShoeSize'
      belongs_to :shoe_type,class_name: 'BxBlockProductProperties::ShoeType'
     end
end 