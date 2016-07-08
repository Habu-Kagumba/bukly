require "rails_helper"

RSpec.describe User, type: :model do
  let(:email) { FFaker::Internet.safe_email }
  subject { create(:user, email: email.upcase) }

  describe "Model validation" do
    it "factory is valid" do
      should be_valid
    end
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should have_many(:buckets).with_foreign_key("created_by") }
    it do
      should_not allow_values(
        FFaker::Internet.domain_name,
        FFaker::Internet.domain_suffix
      ).for(:email)
    end
    it "downcases emails" do
      expect(subject.email).to eql email
    end
  end
end
