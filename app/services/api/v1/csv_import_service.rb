# frozen_string_literal: true

require "csv"

class Api::V1::CsvImportService
  def self.import(file_path)
    CSV.foreach(file_path, headers: true, col_sep: "|", liberal_parsing: true, skip_blanks: true) do |row|
      product_data = {
        brand: row["brand"],
        color: row["color"],
        memory: row["memory"],
        model_label: row["model_label"],
        model_number: row["model_number"]
      }

      supplier_data = {
        name: row["supplier"],
        phone_number: row["phone_number"]
      }

      product_supplier_data = {
        country: row["country"],
        estimate: row["estimate"],
        location: row["location"],
        price: row["price"],
        quantity: row["quantity"],
        status: ProductSupplier.statuses[row["status"]],
        stock_condition: ProductSupplier.stock_conditions[row["stock_condition"]]
      }
      supplier = Supplier.find_or_create_by!(supplier_data)

      product = Product.find_or_create_by!(product_data)

      ProductSupplier.find_or_create_by!(
        product_id: product.id,
        supplier_id: supplier.id,
        country: product_supplier_data[:country]
      ) do |product_supplier|
        product_supplier.update!(product_supplier_data)
      end
    end
  rescue StandardError => e
    Rails.logger.error "Error importing CSV: #{e.message}"
    raise e
  end
end
