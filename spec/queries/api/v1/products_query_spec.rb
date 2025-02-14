# frozen_string_literal: true

RSpec.describe Api::V1::ProductsQuery do
  let(:filters) { {} }
  let(:sort_by) { nil }
  let(:sort_order) { nil }
  let(:query) { described_class.new(filters, sort_by, sort_order) }

  let!(:product1) { create(:product, brand: "Apple", model_label: "iPhone 13 Pro", model_number: "1234", memory: "8GB", color: "Blue") }
  let!(:product2) { create(:product, brand: "Samsung", model_label: "Galaxy S21", model_number: "5678", memory: "10GB", color: "White") }
  let!(:product3) { create(:product, brand: "Apple", model_label: "iPhone 12", model_number: "9101", memory: "10GB", color: "Black") }

  let!(:supplier1) { create(:supplier, name: "ABC") }
  let!(:supplier2) { create(:supplier, name: "XYZ") }

  let!(:product_supplier1) do
    create(
      :product_supplier,
      product: product1,
      supplier: supplier1,
      status: 1,
      stock_condition: 2,
      country: "China",
      estimate: "2-3 days",
      location: "123 Stock"
    )
  end
  let!(:product_supplier2) do
    create(
      :product_supplier,
      product: product2,
      supplier: supplier2,
      status: 2,
      stock_condition: 1,
      country: "Turkey",
      estimate: "4-6 days",
      location: "981 Stock"
    )
  end
  let!(:product_supplier3) do
    create(:product_supplier,
      product: product3,
      supplier: supplier1,
      status: 1,
      stock_condition: 2,
      country: "Tunisia",
      estimate: "2-3 days",
      location: "123 Stock"
    )
  end

  describe "#call" do
    let(:result) { query.call }

    context "no filter and no sorting applied" do
      it "returns all products" do
        expect(result).to eq([ product1, product2, product3 ])
      end
    end

    context "when products are filtered" do
      context "by brand" do
        let(:filters) { { brand: "Apple" } }

        it "fetches products by brand" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by model_label" do
        let(:filters) { { model_label: "iPhone" } }

        it "fetches products by model_label" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by model_number" do
        let(:filters) { { model_number: "1234" } }

        it "fetches products by model_number" do
          expect(result).to contain_exactly(product1)
        end
      end

      context "by memory" do
        let(:filters) { { memory: "10GB" } }

        it "fetches products by memory" do
          expect(result).to contain_exactly(product2, product3)
        end
      end

      context "by color" do
        let(:filters) { { color: "bl" } }

        it "fetches products by color" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by product supplier status" do
        let(:filters) { { status: "1" } }

        it "fetches products by status" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by product supplier stock_condition" do
        let(:filters) { { stock_condition: "1" } }

        it "fetches products by stock_condition" do
          expect(result).to contain_exactly(product2)
        end
      end

      context "by product supplier_name" do
        let(:filters) { { supplier_name: "ABC" } }

        it "fetches products by stock_condition" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by product country" do
        let(:filters) { { country: "tu" } }

        it "fetches products by country" do
          expect(result).to contain_exactly(product2, product3)
        end
      end

      context "by product estimate" do
        let(:filters) { { estimate: "2-3" } }

        it "fetches products by estimate" do
          expect(result).to contain_exactly(product1, product3)
        end
      end

      context "by product location" do
        let(:filters) { { location: "981 Stock" } }

        it "fetches products by location" do
          expect(result).to contain_exactly(product2)
        end
      end
    end

    context "with sorting" do
      it "sorts products by brand in ascending order" do
        query = described_class.new({}, "brand", "asc")
        expect(query.call).to eq([ product1, product3, product2 ])
      end

      it "sorts products by brand in descending order" do
        query = described_class.new({}, "brand", "desc")
        expect(query.call).to eq([ product2, product1, product3 ])
      end

      it "sorts products by model_label in ascending order" do
        query = described_class.new({}, "model_label", "asc")
        expect(query.call).to eq([ product2, product3, product1 ])
      end

      it "sorts products by model_label in descending order" do
        query = described_class.new({}, "model_label", "desc")
        expect(query.call).to eq([ product1, product3, product2 ])
      end
    end

    context "with combined filters and sorting" do
      it "filters by brand and sorts by model_label" do
        query = described_class.new({ brand: "Apple" }, "model_label", "desc")
        expect(query.call).to eq([ product1, product3 ])
      end
    end
  end
end
