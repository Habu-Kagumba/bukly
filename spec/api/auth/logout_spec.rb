require "rails_helper"

RSpec.describe "POST /auth/logout", type: :request do
  let(:user) { create(:user) }
  let(:attrs) do
    {
      email: user.email,
      password: user.password
    }
  end

  let!(:req) { get "/auth/logout", {}, auth_headers }
  subject { response }

  context "when a user tries to logout" do
    it_behaves_like "api_response", 200, "success"
    it_behaves_like "response_message", "message", "logged_out"
  end

  context "when a user is already logged out" do
    before { get "/auth/logout", {}, auth_headers }

    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "expired_sig"
  end
end
