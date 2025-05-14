# frozen_string_literal: true

# == Schema Information
#
# Table name: product_suppliers
#
#  id              :bigint           not null, primary key
#  country         :string
#  estimate        :string
#  location        :string
#  price           :decimal(10, 2)
#  quantity        :integer
#  status          :integer          default("unavailable")
#  stock_condition :integer          default("unknown")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint           not null
#  supplier_id     :bigint           not null
#
# Indexes
#
#  index_product_suppliers_on_product_id   (product_id)
#  index_product_suppliers_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (supplier_id => suppliers.id)
#
class ProductSupplier < ApplicationRecord
  belongs_to :product
  belongs_to :supplier

  enum :status, [ :unavailable, :ready, :booking, :incoming ], default: :unavailable
  enum :stock_condition, [ :unknown, :master_carton, :loose_clean, :loose_dirty ], default: :unknown

  validates :country, :price, :quantity, :status, :stock_condition, :estimate, :location, presence: true
end
