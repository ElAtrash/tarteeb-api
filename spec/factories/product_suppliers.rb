# frozen_string_literal: true

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
