require "rails_helper"

RSpec.describe "POST /auth/login", type: :request do
  let(:user) { create(:user) }
  let(:attrs) do
    {
      email: user.email,
      password: user.password
    }
  end

  let!(:req) { post "/auth/login", attrs, headers }
  subject { response }

  context "when a user logs in with invalid parameters" do
    let(:attrs) { attributes_for(:user) }

    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "access_denied"
  end

  context "when a user logs in" do
    it_behaves_like "api_response", 200, "success_login"
    it_behaves_like "response_message", "message", "logged_in"
  end
end
