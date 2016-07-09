require "rails_helper"

RSpec.describe Api::UsersController, type: :controller do
  let!(:existing_user) { create(:user) }
  let(:headers) do
    {
      accept: "application/vnd.bukly+json; version=1"
    }
  end

  before do
    request.headers["accept"] = headers.fetch(:accept)
  end

  describe "Create user" do
    context "when a user signs up" do
      it "returns a success message and the authentication token" do
        expect do
          post :create, attributes_for(:user)
        end.to change { User.count }.by(1)
      end

      it "returns a validation error if user already exists" do
        param = {
          email: existing_user.email,
          password: existing_user.password
        }
        post :create, param

        expect(response).to have_http_status 422
        expect(json.fetch("errors")).to include "Email has already been taken"
      end

      it "returns validation error if params invalid" do
        param = {
          email: Faker::Lorem.word,
          password: Faker::Internet.password
        }
        post :create, param

        expect(response).to have_http_status 422
        expect(json.fetch("errors")).to include "Email is invalid"
      end
    end
  end
end
