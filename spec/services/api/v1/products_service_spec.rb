# frozen_string_literal: true


RSpec.describe Api::V1::ProductsService, type: :service do
  let(:filters) { { brand: "Apple" } }
  let(:page) { 1 }
  let(:page_size) { 10 }
  let(:sort_by) { "brand" }
  let(:sort_order) { "asc" }
  let(:products_query) { instance_double(Api::V1::ProductsQuery) }
  let(:products) { create_list(:product, 3) }
  let(:paginated_products) { Kaminari.paginate_array(products).page(page).per(page_size) }

  before do
    allow(Api::V1::ProductsQuery).to receive(:new).with(filters, sort_by, sort_order).and_return(products_query)
    allow(products_query).to receive(:call).and_return(paginated_products)
  end

  describe "#call" do
    context "when the query is successful" do
      let(:service) { described_class.new(filters: filters, page: page, page_size: page_size, sort_by: sort_by, sort_order: sort_order) }
      let(:result) { service.call }

      it "returns a successful response with serialized products" do
        aggregate_failures do
          expect(result.success?).to be true
          expect(result.products.serializable_hash).to eq(Api::V1::ProductsSerializer.new(paginated_products, service.send(:options)).serializable_hash)
        end
      end

      it "includes pagination metadata" do
        expect(result.products.serializable_hash[:meta]).to include(
          pages: paginated_products.total_pages,
          total_products: paginated_products.total_count
        )
      end

      it "includes status and stock condition options" do
        expect(result.products.serializable_hash[:meta]).to include(
          status_options: ProductSupplier.statuses.map { |k, v| { label: k.humanize, value: v } },
          stock_condition_options: ProductSupplier.stock_conditions.map { |k, v| { label: k.humanize, value: v } }
        )
      end
    end

    context "when the query raises an ActiveRecord error" do
      let(:service) { described_class.new(filters: filters, page: page, page_size: page_size, sort_by: sort_by, sort_order: sort_order) }
      let(:error) { ActiveRecord::RecordInvalid.new(Product.new) }

      before do
        allow(products_query).to receive(:call).and_raise(error)
      end

      it "returns an error response" do
        result = service.call
        aggregate_failures do
          expect(result.success?).to be false
          expect(result.error).to eq(error)
        end
      end
    end

    context "when filters are missing" do
      let(:filters) { {} }
      let(:sort_order) { }
      let(:sort_by) { }
      let(:service) { described_class.new(page: page, page_size: page_size) }
      let(:result) { service.call }

      it "returns a successful response with all products" do
        aggregate_failures do
          expect(result.success?).to be true
          expect(result.products.serializable_hash).to eq(Api::V1::ProductsSerializer.new(paginated_products, service.send(:options)).serializable_hash)
        end
      end
    end
  end
end
