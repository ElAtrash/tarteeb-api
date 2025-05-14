# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :authenticate_request
  attr_reader :current_user

  protected

  def api_error(error, status = nil)
    if error.kind_of?(ActiveRecord::Base)
      error = error.errors.full_messages.first
    end
    render json: { error: error }, status: status || ActionDispatch::ExceptionWrapper.rescue_responses[error.class.name]
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    if token
      decoded = JwtService.decode(token)
      if decoded
        @current_user = User.find_by(id: decoded[:user_id])
      end
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
