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

RSpec.describe Product, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
