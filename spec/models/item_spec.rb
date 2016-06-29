require "rails_helper"

RSpec.describe Item, type: :model do
  subject { create(:item) }

  describe "Model validation" do
    it "factory is valid" do
      should be_valid
    end
    it { should validate_presence_of(:name) }
    it { should belong_to(:bucket) }
  end
end
