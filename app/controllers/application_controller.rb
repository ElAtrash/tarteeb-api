class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  protected

  def api_error(error, status = nil)
    if error.kind_of?(ActiveRecord::Base)
      error = error.errors.full_messages.first
    end
    render json: { error: error }, status: status || ActionDispatch::ExceptionWrapper.rescue_responses[error.class.name]
  end
end
