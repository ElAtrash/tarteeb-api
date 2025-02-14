# frozen_string_literal: true

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    let(:products_service) { instance_double(Api::V1::ProductsService) }
    let(:products) { create_list(:product, 3) }

    before do
      allow(Api::V1::ProductsService).to receive(:new).and_return(products_service)
    end

    context "when the service call is successful" do
      let(:success_result) { OpenStruct.new(success?: true, products: products) }

      before do
        allow(products_service).to receive(:call).and_return(success_result)
      end

      it "returns a successful response with products" do
        get :index

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq(JSON.parse(products.to_json))
        end
      end
    end

    context "when the service call fails" do
      let(:error) { StandardError.new("error message") }
      let(:error_result) { OpenStruct.new(success?: false, error: error) }

      before do
        allow(products_service).to receive(:call).and_return(error_result)
      end

      it "returns an error response with the custom error message" do
        get :index

        aggregate_failures do
          expect(response).to have_http_status(:internal_server_error)
          expect(JSON.parse(response.body)).to eq({ "error" => "error message" })
        end
      end
    end

    context "with filters" do
      let(:filters) { { brand: "Apple" } }
      let(:success_result) { OpenStruct.new(success?: true, products: products) }

      before do
        allow(products_service).to receive(:call).and_return(success_result)
      end

      it "passes filters to the service" do
        get :index, params: { filters: filters }

        expect(Api::V1::ProductsService).to have_received(:new).with(
          filters: filters.to_h,
          page: nil,
          page_size: nil,
          sort_by: nil,
          sort_order: nil
        )
      end
    end

    context "with pagination" do
      let(:success_result) { OpenStruct.new(success?: true, products: products) }

      before do
        allow(products_service).to receive(:call).and_return(success_result)
      end

      it "passes pagination parameters to the service" do
        get :index, params: { page: 2, pageSize: 10 }

        expect(Api::V1::ProductsService).to have_received(:new).with(
          filters: {},
          page: "2",
          page_size: "10",
          sort_by: nil,
          sort_order: nil
        )
      end
    end

    context "with sorting" do
      let(:success_result) { OpenStruct.new(success?: true, products: products) }

      before do
        allow(products_service).to receive(:call).and_return(success_result)
      end

      it "passes sorting parameters to the service" do
        get :index, params: { sort_by: "brand", sort_order: "asc" }

        expect(Api::V1::ProductsService).to have_received(:new).with(
          filters: {},
          page: nil,
          page_size: nil,
          sort_by: "brand",
          sort_order: "asc"
        )
      end
    end
  end
end
