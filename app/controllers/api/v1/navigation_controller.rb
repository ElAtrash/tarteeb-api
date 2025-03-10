# frozen_string_literal: true

class Api::V1::NavigationController < ApplicationController
  def index
    navigation_links = Api::V1::NavigationService.navigation_links
    render json: Api::V1::NavigationSerializer.new(navigation_links).serializable_hash
  end
end
