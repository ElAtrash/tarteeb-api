# frozen_string_literal: true

module AuthHelper
  def auth_headers(user)
    token = JwtService.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
