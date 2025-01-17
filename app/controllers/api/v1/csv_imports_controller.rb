# frozen_string_literal: true

class Api::V1::CsvImportsController < ApplicationController
  def import
    file = params[:file]

    if file.blank? || !file.respond_to?(:path)
      render json: { error: "No file uploaded" }, status: :unprocessable_entity
      return
    end

    begin
      Api::V1::CsvImportService.import(file.path)
      render json: { message: "CSV imported successfully" }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
