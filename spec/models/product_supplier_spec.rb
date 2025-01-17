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
#  status          :integer          default(0)
#  stock_condition :integer          default(0)
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

RSpec.describe ProductSupplier, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
