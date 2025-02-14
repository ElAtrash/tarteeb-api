# frozen_string_literal: true

FactoryBot.define do
  factory :supplier do
    name { Faker::Commerce.vendor }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
