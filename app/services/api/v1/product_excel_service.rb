# frozen_string_literal: true

class Api::V1::ProductExcelService
  PRODUCT_HEADER = [ "Brand", "Model Label", "Memory", "Color" ].freeze
  SUBHEADER = [ "Spec", "Price in USD", "Quantity", "Stock Condition", "Location", "Status", "Estimate" ].freeze
  FUNCTION_HEADER = [ "Cheapest Offer", "Average", "Cheapest Offer + 1%", "Average + 1%" ].freeze
  UPLIFT_FACTOR = 1.01

  attr_reader :filters, :sort_by, :sort_order

  def initialize(filters = {}, sort_by = nil, sort_order = nil)
    @filters = filters
    @sort_by = sort_by
    @sort_order = sort_order
  end

  def generate
    build_excel
    xlsx_package
  end

  private

  def build_excel
    add_headers
    add_data
  end

  def add_headers
    work_book.add_worksheet(name: "Products") do |sheet|
      build_header(sheet)
      build_subheader(sheet)
    end
  end

  def build_header(sheet)
    supplier_headers = []
    suppliers.each do |supplier|
      supplier_headers << supplier
      supplier_headers.concat(Array.new(6, ""))
    end
    sheet.add_row(PRODUCT_HEADER + supplier_headers + FUNCTION_HEADER, style: header_style)

    merge_header_cells(sheet)
  end

  def merge_header_cells(sheet)
    sheet.merge_cells("A1:A2") # Brand
    sheet.merge_cells("B1:B2") # Model Label
    sheet.merge_cells("C1:C2") # Memory
    sheet.merge_cells("D1:D2") # Color

    suppliers.each_with_index do |_, index|
      start_col = PRODUCT_HEADER.size + (index * 7) + 1
      sheet.merge_cells(sheet.rows[0].cells[start_col - 1, 7])
      sheet.rows[0].cells[start_col - 1].style = centered_header_style
    end

    FUNCTION_HEADER.each_with_index do |_, index|
      start_col = PRODUCT_HEADER.size + (suppliers.size * 7) + index + 1
      sheet.merge_cells("#{Axlsx.col_ref(start_col - 1)}1:#{Axlsx.col_ref(start_col - 1)}2")
    end
  end

  def build_subheader(sheet)
    subheaders = Array.new(4, "")
    subheaders += SUBHEADER * suppliers.length
    sheet.add_row(subheaders, style: header_style)
  end

  def add_data
    work_book.worksheets.first.tap do |sheet|
      current_row = 3

      grouped_products.each do |brand, model_label_groups|
        brand_start_row = current_row

        model_label_groups.each do |model_label, products|
          model_label_start_row = current_row

          products.each do |product|
            add_product_row(sheet, product, suppliers, current_row)
            current_row += 1
          end

          merge_cells_vertically(sheet, "B", model_label_start_row, current_row - 1) if products.size > 1
        end

        merge_cells_vertically(sheet, "A", brand_start_row, current_row - 1) if model_label_groups.values.flatten.size > 1
      end
    end
  end

  def add_product_row(sheet, product, suppliers, current_row)
    row = [ product.brand, product.model_label, product.memory, product.color ]
    product_prices = []

    suppliers.each do |supplier_name|
      product_supplier = find_product_supplier(product, supplier_name)
      row += build_supplier_row(product_supplier)
      product_prices << product_supplier.price if product_supplier
    end

    row += calculate_pricing(product_prices)
    sheet.add_row(row, style: basic_info_style)
  end

  def find_product_supplier(product, supplier_name)
    product.product_suppliers.joins(:supplier).find_by(suppliers: { name: supplier_name })
  end

  def build_supplier_row(product_supplier)
    if product_supplier
      [
        product_supplier.country,
        product_supplier.price.to_f,
        product_supplier.quantity,
        product_supplier.stock_condition.titleize,
        product_supplier.location,
        product_supplier.status.titleize,
        product_supplier.estimate
      ]
    else
      Array.new(7, "")
    end
  end

  def calculate_pricing(product_prices)
    cheapest_offer = product_prices.min
    average_price = product_prices.sum / product_prices.length
    [ cheapest_offer, average_price, cheapest_offer * UPLIFT_FACTOR, average_price * UPLIFT_FACTOR ]
  end

  def merge_cells_vertically(sheet, column, start_row, end_row)
    sheet.merge_cells("#{column}#{start_row}:#{column}#{end_row}")
  end

  def xlsx_package
    @xlsx_package ||= Axlsx::Package.new
  end

  def work_book
    @work_book ||= xlsx_package.workbook
  end

  def styles
    @styles ||= work_book.styles
  end

  def header_style
    @header_style ||= styles.add_style(basic_info_style_hash.merge(b: true))
  end

  def centered_header_style
    @centered_header_style ||= styles.add_style(
      basic_info_style_hash.merge(
        b: true,
        alignment: { horizontal: :center, vertical: :center }
      )
    )
  end

  def basic_info_style
    @basic_info_style ||= styles.add_style(basic_info_style_hash)
  end

  def basic_info_style_hash
    {
      sz: 11,
      font_name: "Calibri",
      alignment: { horizontal: :left, vertical: :top, wrap_text: true }
    }
  end

  def products
    @products ||= Api::V1::ProductsQuery.new(filters, sort_by, sort_order).call
  end

  def grouped_products
    return [] if products.blank?

    @products.group_by(&:brand).transform_values do |brand_products|
      brand_products.group_by(&:model_label)
    end
  end

  def suppliers
    @suppliers ||= products.flat_map(&:suppliers).map(&:name).uniq
  end
end
