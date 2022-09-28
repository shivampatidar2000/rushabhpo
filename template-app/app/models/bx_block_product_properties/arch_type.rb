module BxBlockProductProperties
    class ArchType < BxBlockProductProperties::ApplicationRecord
      self.table_name = :arch_types
    #   accepts_nested_attributes_for :product_details, allow_destroy: true
    end
  end
  