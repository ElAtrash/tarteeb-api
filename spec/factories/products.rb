# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    brand { Faker::Commerce.brand }
    color { Faker::Commerce.color }
    memory { "#{rand(8..1024)}GB" }
    model_label { Faker::Commerce.product_name }
    model_number { Faker::Device.serial }
  end
end
