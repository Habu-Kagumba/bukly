require "rails_helper"

RSpec.describe ApplicationController, type: :request do
  let(:user) { create(:user, logged_in: true) }
  let(:auth_token) { token(user) }
  let(:headers) do
    {
      accept: "application/vnd.bukly+json; version=1",
      authorization: auth_token
    }
  end

  describe "Undefined endpoints" do
    context "when a user visits a non-existing endpoint" do
      it "responds with a 404 - not found error" do
        route = FFaker::Lorem.word
        get "/#{route}", {}, headers

        expect(response).to have_http_status 404
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.not_found
      end
    end
  end
end
