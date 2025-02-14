# frozen_string_literal: true

RSpec.describe Api::V1::ProductSuppliersSerializer, type: :serializer do
  let(:product) { create(:product) }
  let(:supplier) { create(:supplier) }
  let(:product_supplier) { create(:product_supplier, product: product, supplier: supplier) }
  let(:serializer) { described_class.new(product_supplier) }
  let(:serialized_attributes) { serializer.serializable_hash[:data][:attributes] }

  describe "attributes" do
    it "includes correct attributes" do
      expect(serialized_attributes.keys).to contain_exactly(
        :id, :supplier_id, :country, :estimate, :location, :price, :quantity, :status, :stock_condition, :supplier_name
      )
    end

    it "includes the correct values for the attributes" do
      aggregate_failures do
        expect(serialized_attributes[:supplier_id]).to eq(product_supplier.supplier_id)
        expect(serialized_attributes[:country]).to eq(product_supplier.country)
        expect(serialized_attributes[:estimate]).to eq(product_supplier.estimate)
        expect(serialized_attributes[:location]).to eq(product_supplier.location)
        expect(serialized_attributes[:price]).to eq(product_supplier.price)
        expect(serialized_attributes[:quantity]).to eq(product_supplier.quantity)
        expect(serialized_attributes[:status]).to eq(product_supplier.status)
        expect(serialized_attributes[:stock_condition]).to eq(product_supplier.stock_condition)
        expect(serialized_attributes[:supplier_name]).to eq(product_supplier.supplier.name)
      end
    end
  end
end
