# == Schema Information
#
# Table name: suppliers
#
#  id           :bigint           not null, primary key
#  name         :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Supplier < ApplicationRecord
  has_many :product_suppliers
  has_many :products, through: :product_suppliers
end
