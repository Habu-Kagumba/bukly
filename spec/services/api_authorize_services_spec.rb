require "rails_helper"

RSpec.describe ApiAuthorizeService do
  let(:logged_out_user) { create(:user) }
  let(:logged_in_user) { create(:logged_in_user) }

  def auth_headers(user_type)
    {
      "Authorization" => token(user_type)
    }
  end

  def service(headers = {})
    described_class.new(headers)
  end

  describe "Authorize user" do
    it "authorize user using the authorization header" do
      expect(service(auth_headers(logged_in_user)).authorize).
        to eql logged_in_user
    end

    it "raises an error if user not logged in" do
      expect do
        service(auth_headers(logged_out_user)).authorize
      end.to raise_error ExceptionHandlers::NotAuthenticatedError
    end

    it "raises an error if authorization header missing" do
      expect do
        service.authorize
      end.to raise_error ExceptionHandlers::AccessDeniedError
    end

    it "raises error if token is incorrect" do
      expect do
        service("Authorization" => FFaker::Guid.guid).authorize
      end.to raise_error ExceptionHandlers::NotAuthenticatedError
    end

    it "raises an error when token is expired" do
      Timecop.travel(2.month.from_now)

      expect do
        service(auth_headers(logged_in_user)).authorize
      end.to raise_error ExceptionHandlers::ExpiredSignatureError

      Timecop.return
    end
  end
end
