# frozen_string_literal: true

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
FactoryBot.define do
  factory :supplier do
    name { Faker::Commerce.vendor }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
