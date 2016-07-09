require "rails_helper"

RSpec.describe AuthenticationService do
  let(:user) { create(:user) }
  let(:new_user_attrs) { attributes_for(:user) }

  describe "Authenticate user" do
    context "when the user exists" do
      subject { described_class.new(user.email, user.password) }

      it "Logs in a user" do
        subject.login
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

    context "when a user signsup for a new account" do
      subject do
        described_class.new(
          new_user_attrs[:email],
          new_user_attrs[:password]
        )
      end

      it "creates the user and logs the user in" do
        expect do
          subject.create_user
        end.to change { User.count }.by(1)
      end
    end

    context "when a user signsup with invalid parameters" do
      subject do
        described_class.new(
          FFaker::Lorem.word,
          new_user_attrs[:password]
        )
      end

      it "return a validation error" do
        expect do
          subject.create_user
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
