# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  first_name      :string
#  last_name       :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@tarteeb.net" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { "$B@b4$DS!%cTFHua&od^sX!" }
  end
end
