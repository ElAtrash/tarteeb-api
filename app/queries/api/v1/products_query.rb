# frozen_string_literal: true

class Api::V1::ProductsQuery
  attr_reader :filters, :sort_by, :sort_order

  def initialize(filters = {}, sort_by = nil, sort_order = nil)
    @filters = filters
    @sort_by = sort_by
    @sort_order = sort_order
  end

  def call
    query
  end

  private

  def query
    Product.includes(:product_suppliers, :suppliers).references(:product_suppliers, :suppliers).where(condition).order(order)
  end

  def condition
    return if filters.blank?

    filters.map do |filter|
      build_condition(filter)
    end.join(" and ")
  end

  def build_condition(filter)
    column, value = filter

    case column.to_sym
    when :brand, :model_label, :model_number, :memory, :color then products_condition(column, value)
    when :status, :stock_condition then enum_condition(column, value)
    when :supplier_name then ar.sanitize_sql([ "suppliers.name ILIKE ?", "%#{value}%" ])
    else product_suppliers_condition(column, value)
    end
  end

  def products_condition(column, value)
    ar.sanitize_sql([ "products.#{column} ILIKE ?", "%#{value}%" ])
  end

  def product_suppliers_condition(column, value)
    ar.sanitize_sql([ "product_suppliers.#{column} ILIKE ?", "%#{value}%" ])
  end

  def enum_condition(column, value)
    ar.sanitize_sql([ "product_suppliers.#{column} = ?", value.to_i ])
  end

  def ar
    ActiveRecord::Base
  end

  def order
    return unless sort_by && sort_order

    "#{sort_by} #{sort_order}"
  end
end
