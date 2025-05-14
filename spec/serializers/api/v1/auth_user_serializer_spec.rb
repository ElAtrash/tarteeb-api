# frozen_string_literal: true

RSpec.describe Api::V1::AuthUserSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialized_attributes) { serializer.serializable_hash[:data][:attributes] }

  describe "attributes" do
    it "includes correct attributes" do
      expect(serialized_attributes.keys).to contain_exactly(:id, :email, :first_name, :last_name)
    end
  end
end
