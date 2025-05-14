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
FactoryBot.define do
  factory :product_supplier do
    product
    supplier
    country { Faker::Address.country }
    estimate { "#{rand(1..10)} days" }
    location { Faker::Address.street_name }
    price { Faker::Commerce.price }
    quantity { "#{rand(1..500)}" }
    status { "booking" }
    stock_condition { "loose_clean" }
  end
end
