# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end
