# frozen_string_literal: true

RSpec.describe Api::V1::CsvImportService, type: :service do
  describe ".import" do
    let(:csv_file_path) { Rails.root.join("spec/fixtures/files/import_products.csv") }

    context "when the CSV is valid" do
      it "imports products, suppliers, and product suppliers from the CSV file" do
        expect { described_class.import(csv_file_path) }
          .to change { Product.count }.by(7)
          .and change { Supplier.count }.by(3)
          .and change { ProductSupplier.count }.by(8)

        product = Product.last
        supplier = Supplier.last
        product_supplier = ProductSupplier.last

        expect(product.brand).to eq("Apple")
        expect(product.color).to eq("Black")
        expect(product.memory).to eq("1tb")
        expect(product.model_label).to eq("iPhone 15 Pro")
        expect(product.model_number).to eq("1234")

        expect(supplier.name).to eq("XYZ")
        expect(supplier.phone_number).to eq("+11111111")

        expect(product_supplier.country).to eq("Brazil")
        expect(product_supplier.estimate).to eq("12 days")
        expect(product_supplier.location).to eq("edw india")
        expect(product_supplier.price.to_f).to eq(1395.0)
        expect(product_supplier.quantity).to eq(120)
        expect(product_supplier.status).to eq("unavailable")
        expect(product_supplier.stock_condition).to eq("master_carton")
      end
    end
  end
end
