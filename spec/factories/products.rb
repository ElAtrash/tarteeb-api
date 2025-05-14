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
FactoryBot.define do
  factory :product do
    brand { Faker::Commerce.brand }
    color { Faker::Commerce.color }
    memory { "#{rand(8..1024)}GB" }
    model_label { Faker::Commerce.product_name }
    model_number { Faker::Device.serial }
  end
end
