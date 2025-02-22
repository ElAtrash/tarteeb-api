# frozen_string_literal: true

RSpec.describe Api::V1::ProductsController, type: :request do
  describe "GET #index" do
    let!(:product1) { create(:product, brand: "Apple", model_label: "iPhone 12", memory: "8GB", color: "White") }
    let!(:product2) { create(:product, brand: "Samsung", model_label: "Galaxy S21", memory: "12GB", color: "Black") }
    let!(:supplier1) { create(:supplier, name: "Supplier A") }
    let!(:supplier2) { create(:supplier, name: "Supplier B") }

    before do
      create(:product_supplier, product: product1, supplier: supplier1, price: 400, quantity: 100, stock_condition: "loose_clean", status: "ready", estimate: "2-3 days")
      create(:product_supplier, product: product1, supplier: supplier2, price: 450, quantity: 50, stock_condition: "master_carton", status: "booking", estimate: "1-2 days")
    end

    let(:filters) { {} }
    let(:sort_by) { nil }
    let(:sort_order) { nil }

    subject(:get_request) do
      get api_v1_products_url, params: { filters: filters, sort_by: sort_by, sort_order: sort_order }
    end

    context "with filters" do
      let(:filters) { { brand: "Apple" } }

      it "returns filtered products" do
        get_request

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(body, symbolize_names: true)

          expect(json_response.dig(:meta, :total_products)).to eq(1)
          expect(json_response[:data][0][:attributes][:brand]).to eq("Apple")
        end
      end
    end

    context "with sorting" do
      let(:sort_by) { "price" }
      let(:sort_order) { "desc" }

      it "returns products sorted by price in descending order" do
        get_request

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(body, symbolize_names: true)

          expect(json_response[:data][0][:attributes][:brand]).to eq("Samsung")
          expect(json_response[:data][1][:attributes][:brand]).to eq("Apple")
        end
      end
    end

    context "with invalid filters" do
      let(:filters) { { brand: "Invalid Brand" } }

      it "returns an empty array" do
        get_request

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(body, symbolize_names: true)

          expect(json_response.dig(:meta, :total_products)).to be_zero
          expect(json_response[:data]).to be_empty
        end
      end
    end

    context "when an error occurs" do
      let(:error_result) { OpenStruct.new(success?: false, error: StandardError.new("error message")) }

      before do
        allow_any_instance_of(Api::V1::ProductsService).to receive(:call).and_return(error_result)
      end

      it "returns an error response" do
        get_request

        aggregate_failures do
          expect(response).to have_http_status(:internal_server_error)
          json_response = JSON.parse(body)

          expect(json_response["error"]).to eq("error message")
        end
      end
    end
  end

  describe "POST /api/v1/products/export" do
    let(:products) { create_list(:product, 3) }

    context "with valid filters and sorting" do
      it "returns an Excel file with the correct headers and content" do
        post export_api_v1_products_url, params: { filters: { brand: "Apple" }, sort_by: "price", sort_order: "asc" }

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.headers["Content-Disposition"]).to include('filename="products.xlsx"')
          expect(response.headers["Content-Type"]).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        end
      end
    end
  end
end
