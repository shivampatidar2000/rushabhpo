module BxBlockProductProperties
    class TemplateWidth < BxBlockProductProperties::ApplicationRecord
      self.table_name = :template_widths
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
    end
  end