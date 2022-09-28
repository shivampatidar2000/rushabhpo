module BxBlockProductProperties
    class TemplateLength < BxBlockProductProperties::ApplicationRecord
      self.table_name = :template_lengths
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
    
        def display_name
          self.template_length
      end
    end
  end