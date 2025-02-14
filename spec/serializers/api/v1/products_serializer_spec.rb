# frozen_string_literal: true

RSpec.describe Api::V1::ProductsSerializer, type: :serializer do
  let(:product) { create(:product) }
  let(:serializer) { described_class.new(product) }
  let(:serialized_attributes) { serializer.serializable_hash[:data][:attributes] }

  describe "attributes" do
    it "includes correct attributes" do
      expect(serialized_attributes.keys).to contain_exactly(
        :brand, :model_label, :memory, :model_number, :color, :product_suppliers
      )
    end

    it "includes the correct values for the attributes" do
      aggregate_failures do
        expect(serialized_attributes[:brand]).to eq(product.brand)
        expect(serialized_attributes[:model_label]).to eq(product.model_label)
        expect(serialized_attributes[:memory]).to eq(product.memory)
        expect(serialized_attributes[:model_number]).to eq(product.model_number)
        expect(serialized_attributes[:color]).to eq(product.color)
      end
    end

    context "when some attributes are missing" do
      let(:product) { create(:product, model_number: nil) }

      it "includes nil values for missing attributes" do
        expect(serialized_attributes[:model_number]).to be_nil
      end
    end
  end

  describe "product_suppliers" do
    let(:product_supplier) { create(:product_supplier, product: product) }
    let(:product_suppliers_serializer) { Api::V1::ProductSuppliersSerializer.new(product.product_suppliers) }

    context "when there is a product supplier" do
      before do
        product_supplier
      end

      it "includes the serialized product_suppliers" do
        expect(serialized_attributes[:product_suppliers]).to eq(
          product_suppliers_serializer.serializable_hash
        )
      end
    end

    context "when there are no product suppliers" do
      let(:product) { create(:product) }

      it "includes an empty array for product_suppliers" do
        expect(serialized_attributes[:product_suppliers]).to eq(
          { data: [] }
        )
      end
    end
  end
end
