# frozen_string_literal: true

class Api::V1::ProductSuppliersSerializer
  include JSONAPI::Serializer

  attributes :id, :supplier_id, :country, :estimate, :location, :price, :quantity,
             :status, :stock_condition

  attribute :supplier_name do |product_supplier|
    product_supplier.supplier.name
  end
end
