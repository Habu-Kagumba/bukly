require "rails_helper"

RSpec.describe Bucket, type: :model do
  subject { create(:bucket) }

  describe "Model validation" do
    it "factory should be valid" do
      should be_valid
    end
    it { should validate_presence_of(:name) }
  end
end
