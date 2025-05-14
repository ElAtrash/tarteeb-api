# frozen_string_literal: true

RSpec.describe AuthenticationService, type: :service do
  let(:user) { create(:user, email: "user@tarteeb.net", password: "password123") }

  describe ".login" do
    context "with valid credentials" do
      it "returns a token and user details" do
        result = described_class.login(user.email, "password123")

        expect(result).to include(
          token: be_a(String),
          user: {
            id: user.id,
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name
          }
        )
      end

      it "generates a valid JWT token" do
        result = described_class.login(user.email, "password123")
        decoded_token = JwtService.decode(result[:token])

        expect(decoded_token[:user_id]).to eq(user.id)
      end
    end

    context "with invalid email" do
      it "returns nil" do
        expect(described_class.login("wrong@example.com", "password123")).to be_nil
      end
    end

    context "with invalid password" do
      it "returns nil" do
        expect(described_class.login(user.email, "wrong_password")).to be_nil
      end
    end

    context "when user does not exist" do
      before { user.destroy }

      it "returns nil" do
        expect(described_class.login(user.email, "password123")).to be_nil
      end
    end

    context "when JWT encoding fails" do
      before do
        allow(JwtService).to receive(:encode).and_raise(JWT::EncodeError)
      end

      it "raises an exception" do
        expect {
          described_class.login(user.email, "password123")
        }.to raise_error(JWT::EncodeError)
      end
    end
  end
end
