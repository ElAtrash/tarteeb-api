# frozen_string_literal: true

RSpec.describe Api::V1::ProductsController, type: :request do
  let(:valid_user_attributes) do
    {
      email: "test@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Doe"
    }
  end

  describe "POST /api/v1/auth/login" do
    context "with valid credentials" do
      before do
        User.create!(valid_user_attributes)

        allow(AuthenticationService).to receive(:login).with(
          valid_user_attributes[:email],
          valid_user_attributes[:password]
        ).and_return({ token: "mock_token", user_id: 1 })
      end

      it "returns a token and user_id" do
        post api_v1_auth_login_path, params: {
          email: valid_user_attributes[:email],
          password: valid_user_attributes[:password]
        }

        expect(response).to have_http_status(:ok)
        expect(json_response).to include("token", "user_id")
      end
    end

    context "with invalid credentials" do
      before do
        allow(AuthenticationService).to receive(:login).and_return(nil)
      end

      it "returns unauthorized error" do
        post api_v1_auth_login_path, params: { email: "wrong@example.com", password: "wrongpass" }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to include("error")
      end
    end
  end

  describe "POST /api/v1/auth/register" do
    context "with valid attributes" do
      before do
        allow(AuthenticationService).to receive(:login).and_return({ token: "mock_token", user_id: 1 })
      end

      it "creates a new user and returns authentication token" do
        expect {
          post api_v1_auth_register_path, params: valid_user_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response).to include("token", "user_id")
      end
    end

    context "with invalid attributes" do
      it "does not create a user and returns errors" do
        expect {
          post api_v1_auth_register_path, params: { email: "invalid" }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key("errors")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
