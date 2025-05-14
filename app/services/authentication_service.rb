# frozen_string_literal: true

class AuthenticationService
  def self.login(email, password)
    user = User.find_by(email: email)

    return nil unless user && user.authenticate(password)

    token = JwtService.encode(user_id: user.id)

    {
      token: token,
      user: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name
      }
    }
  end
end
