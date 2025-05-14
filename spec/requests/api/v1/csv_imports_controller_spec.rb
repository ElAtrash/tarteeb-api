# frozen_string_literal: true

RSpec.describe "CSV Imports API", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "POST /api/v1/csv_imports" do
    let(:file_path) { Rails.root.join("spec/fixtures/files/import_products.csv") }
    let(:file) { fixture_file_upload(file_path, "text/csv") }

    context "when the file is uploaded successfully" do
      it "calls the CsvImportService and returns a success message" do
        expect(Api::V1::CsvImportService).to receive(:import).with(kind_of(String)).and_return(true)

        post "/api/v1/csv_imports/import", params: { file: file }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "message" => "CSV imported successfully" })
      end
    end

    context "when no file is uploaded" do
      it "returns an error message" do
        post "/api/v1/csv_imports/import", params: { file: nil }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "No file uploaded" })
      end
    end

    context "when an exception occurs during import" do
      it "returns an error message" do
        allow(Api::V1::CsvImportService).to receive(:import).and_raise(StandardError, "Something went wrong")

        post "/api/v1/csv_imports/import", params: { file: file }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Something went wrong" })
      end
    end
  end
end
