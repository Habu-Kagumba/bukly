require "rails_helper"

RSpec.describe Api::AuthenticationController, type: :controller do
  let(:user) { create(:user) }
  let(:auth_token) { token(user) }
  let(:headers) do
    {
      accept: "application/vnd.bukly+json; version=1",
      authorization: auth_token
    }
  end
  let(:param) do
    { email: user.email, password: user.password }
  end

  before do
    request.headers["accept"] = headers.fetch(:accept)
    request.headers["authorization"] = headers.fetch(:authorization)
  end

  describe "User authentication" do
    context "When an anonymous user tries to login" do
      it "returns an error message" do
        err_param = {
          email: Faker::Internet.safe_email,
          password: Faker::Internet.password
        }
        post :login, err_param

        expect(response).to have_http_status 401
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.access_denied
      end
    end

    context "When a user tries to login" do
      it "returns a success message" do
        post :login, param

        expect(response).to be_success
        expect(json.fetch("message")).
          to eql ExceptionMessages::Messages.logged_in
      end
    end

    context "When a user logs out" do
      before do
        post :login, param
      end

      it "returns a success message" do
        get :logout

        expect(response).to be_success
        expect(json.fetch("message")).
          to eql ExceptionMessages::Messages.logged_out
        expect(user.invalid_tokens.pluck(:token)).
          to include headers[:authorization]
      end
    end

    context "When a user is already logged out" do
      before do
        post :login, param
        get :logout
      end

      it "returns an expired signature error message" do
        get :logout

        expect(response).to have_http_status 401
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.expired_sig
      end
    end
  end
end
