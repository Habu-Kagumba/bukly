require "rails_helper"

RSpec.describe "POST /signup", type: :request do
  let(:attrs) { attributes_for(:user) }
  let(:headers) do
    {
      accept: "application/vnd.bukly+json; version=1"
    }
  end
  let!(:existing_user) { create(:user) }

  let!(:req) { post "/signup", attrs, headers }
  subject { response }

  context "when a new user signs up" do
    it_behaves_like "api_response", 201, "success_login"
    it_behaves_like "response_message", "message", "create_user"
  end

  context "when and existing user signs up" do
    let(:attrs) do
      {
        email: existing_user.email,
        password: existing_user.password
      }
    end

    it_behaves_like "api_response", 422, "errors"
  end

  context "when a new user signs up with the invalid parameters" do
    let(:attrs) do
      {
        email: Faker::Lorem.word,
        password: existing_user.password
      }
    end

    it_behaves_like "api_response", 422, "errors"
  end
end
