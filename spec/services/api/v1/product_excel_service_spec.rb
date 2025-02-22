# frozen_string_literal: true

RSpec.describe Api::V1::ProductExcelService, type: :service do
  let!(:product) { create(:product, brand: "Apple", model_label: "iPhone 13 Pro", memory: "8GB", color: "Blue") }
  let!(:supplier1) { create(:supplier, name: "ABC") }
  let!(:supplier2) { create(:supplier, name: "XYZ") }

  let!(:product_supplier1) do
    create(
      :product_supplier,
      product: product,
      supplier: supplier1,
      status: 1,
      stock_condition: 2,
      country: "China",
      estimate: "2-3 days",
      location: "123 Stock",
      price: "950.70",
      quantity: 500
    )
  end

  let!(:product_supplier2) do
    create(
      :product_supplier,
      product: product,
      supplier: supplier2,
      status: 2,
      stock_condition: 1,
      country: "Turkey",
      estimate: "4-6 days",
      location: "981 Stock",
      price: "951.10",
      quantity: 620
    )
  end

  let(:xlsx_package_mock) { instance_double(Axlsx::Package) }
  let(:workbook_mock) { instance_double(Axlsx::Workbook) }
  let(:worksheet_mock) { instance_double(Axlsx::Worksheet) }

  subject! { described_class.new.generate }

  let(:expected_header) do
    described_class::PRODUCT_HEADER + [ supplier1.name ].concat(Array.new(6, "")) +
    [ supplier2.name ].concat(Array.new(6, ""))  + described_class::FUNCTION_HEADER
  end

  let(:expected_subheader) do
    Array.new(4, "").concat(described_class::SUBHEADER).concat(described_class::SUBHEADER)
  end

  let(:product_prices) { [ product_supplier1.price, product_supplier2.price ] }

  let(:expected_row_values) do
    [
      product.brand,
      product.model_label,
      product.memory,
      product.color,
      product_supplier1.country,
      product_supplier1.price.to_f,
      product_supplier1.quantity,
      product_supplier1.stock_condition.titleize,
      product_supplier1.location,
      product_supplier1.status.titleize,
      product_supplier1.estimate,
      product_supplier2.country,
      product_supplier2.price,
      product_supplier2.quantity,
      product_supplier2.stock_condition.titleize,
      product_supplier2.location,
      product_supplier2.status.titleize,
      product_supplier2.estimate,
      product_prices.min,
      product_prices.sum / product_prices.length,
      product_prices.min * described_class::UPLIFT_FACTOR,
      product_prices.sum / product_prices.length * described_class::UPLIFT_FACTOR
    ]
  end

  before do
    allow(xlsx_package_mock).to receive(:workbook).and_return(workbook_mock)
    allow(workbook_mock).to receive(:add_worksheet).with(name: "Products").and_return(worksheet_mock)
  end

  context "when a document is generated" do
    it "adds expected headers and row to excel document" do
      rows = subject.workbook.worksheets.first.rows

      aggregate_failures "checking header and rows" do
        rows.first.each_with_index do |cell, index|
          expect(cell.value).to eq(expected_header[index])
        end

        rows.second.each_with_index do |cell, index|
          expect(cell.value).to eq(expected_subheader[index])
        end

        rows.last.each_with_index do |cell, index|
          expect(cell.value).to eq(expected_row_values[index])
        end
      end
    end
  end
end
