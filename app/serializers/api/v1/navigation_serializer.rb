# frozen_string_literal: true

class Api::V1::NavigationSerializer
  include JSONAPI::Serializer

  set_id do |record|
    record[:id]
  end

  attribute :title do |record|
    record[:title]
  end

  attribute :path do |record|
    record[:path]
  end

  attribute :children do |record|
    record[:children]
  end
end
