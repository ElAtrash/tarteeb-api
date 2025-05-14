# frozen_string_literal: true

class Api::V1::AuthUserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name
end
