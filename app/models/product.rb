# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id           :bigint           not null, primary key
#  brand        :string
#  color        :string
#  memory       :string
#  model_label  :string
#  model_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Product < ApplicationRecord
  has_many :product_suppliers
  has_many :suppliers, through: :product_suppliers

  validates :brand, :color, :model_label, :memory, presence: true
end
