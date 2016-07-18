require "rails_helper"

RSpec.describe InvalidToken, type: :model do
  subject { create(:invalid_token) }

  describe "Model validation" do
    it { should be_valid }
    it { should validate_presence_of(:token) }
    it { should validate_uniqueness_of(:token) }
    it { should belong_to(:user) }
  end
end
