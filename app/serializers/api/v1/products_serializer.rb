# frozen_string_literal: true

class Api::V1::ProductsSerializer
  include JSONAPI::Serializer

  attributes :brand, :model_label, :memory, :model_number, :color

  attribute :product_suppliers do |product|
    Api::V1::ProductSuppliersSerializer.new(product.product_suppliers).serializable_hash
  end
end
