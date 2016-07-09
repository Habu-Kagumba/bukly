require "rails_helper"

RSpec.describe Bucket, type: :model do
  subject { create(:bucket) }

  describe "Model validation" do
    it "factory should be valid" do
      should be_valid
    end
    it { should validate_presence_of(:name) }
    it { should have_many(:items) }
    it { should belong_to(:user).with_foreign_key("created_by") }
  end

  describe "Names scopes" do
    it "paginates bucket results" do
      create_list(:bucket, 20)
      pager = {
        limit: 14,
        offset: 0
      }

      expect(Bucket.paginate(pager).count).to eql pager[:limit]
    end

    it "searches for matching buckets" do
      datum = Faker::StarWars.character
      search_bucket = create(:bucket, name: datum)
      create_list(:bucket, 5)

      expect(Bucket.search(datum)).to include search_bucket
    end
  end
end
