# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  def index
    result = Api::V1::ProductsService.new(
      filters: filter_params.to_h,
      sort_by: params[:sort_by],
      sort_order: params[:sort_order],
      page: params[:page],
      page_size: params[:page_size]
    ).call

    if result.success?
      render json: result.products
    else
      api_error(result.error)
    end
  end

  def export
    excel_data = Api::V1::ProductExcelService.new(filter_params.to_h, params[:sort_by], params[:sort_order]).generate

    send_data excel_data.to_stream.string,
              filename: "products.xlsx",
              disposition: "attachment"
  end

  private

  def filter_params
    params.fetch(:filters, {}).permit(
      :brand, :model_label, :model_number, :memory, :color,
      :supplier_name, :country, :price, :quantity, :status,
      :stock_condition, :estimate, :location
    )
  end
end
