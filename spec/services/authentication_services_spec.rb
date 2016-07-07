require "rails_helper"

RSpec.describe AuthenticationService do
  let(:user) { create(:user) }

  describe "Authenticate user" do
    context "when the user exists" do
      subject { described_class.new(user.email, user.password) }

      it "Logs in a user" do
        subject.login
        expect(User.find(user.id).logged_in).to be_truthy
      end
    end

    context "when the user is anonymous" do
      subject do
        described_class.new(
          FFaker::Internet.safe_email,
          FFaker::Internet.password
        )
      end

      it "returns an access is denied error" do
        expect do
          subject.login
        end.to raise_error ExceptionHandlers::AccessDeniedError
      end
    end
  end
end
