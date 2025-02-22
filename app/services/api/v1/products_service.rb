# frozen_string_literal: true

class Api::V1::ProductsService
  def initialize(filters: {}, sort_by: nil, sort_order: nil, page: 1, page_size: 10)
    @filters = filters
    @sort_by = sort_by
    @sort_order = sort_order
    @page = page
    @page_size = page_size
  end

  def call
    OpenStruct.new(success?: true, products: Api::V1::ProductsSerializer.new(products, options))
  rescue ActiveRecord::ActiveRecordError => e
    OpenStruct.new(success?: false, error: e)
  end

  private

  def products
    @products ||= Api::V1::ProductsQuery.new(@filters, @sort_by, @sort_order).call.page(@page).per(@page_size)
  end

  def options
    { meta: { pages: products.total_pages,
              total_products: products.total_count,
              status_options: status_options,
              stock_condition_options: stock_condition_options
            }
    }
  end

  def status_options
    ProductSupplier.statuses.map(&options_for_select_method)
  end

  def stock_condition_options
    ProductSupplier.stock_conditions.map(&options_for_select_method)
  end

  def options_for_select_method
    ->(k, v) { { label: k.humanize, value: v } }
  end
end
