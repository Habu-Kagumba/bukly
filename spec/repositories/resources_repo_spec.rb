require "rails_helper"

RSpec.describe ResourcesRepo do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket, created_by: user.id) }
  let(:params) do
    {
      name: FFaker::CheesyLingo.title
    }
  end
  subject(:repo) { described_class.new(user, bucket.id) }

  describe "Find" do
    it "finds a bucket" do
      expect(repo.find_bucket(bucket.id)).to eql bucket
    end

    it "finds an item" do
      items = bucket.items
      expect(repo.find_item(bucket.items.first.id)).to eql items.first
    end

    it "gets all buckets" do
      expect(repo.all_buckets.to_json).to eql Bucket.all.to_json
    end

    it "gets all items" do
      expect(repo.all_items.to_json).
        to eql Item.where(bucket_id: bucket.id).to_json
    end
  end

  describe "Update" do
    it "updates a bucket" do
      repo.update_bucket(bucket.id, params)
      expect(repo.find_bucket(bucket.id).name).to eql params[:name]
    end

    it "updates an item" do
      repo.update_item(bucket.items.first.id, params)
      expect(repo.find_item(bucket.items.first.id).name).to eql params[:name]
    end
  end

  describe "Destroy" do
    it "deletes a bucket" do
      expect do
        repo.destroy_bucket(bucket.id)
      end.to change { repo.all_buckets.count }.by(-1)
    end

    it "deletes an item" do
      expect do
        repo.destroy_item(bucket.items.last.id)
      end.to change { repo.all_items.count }.by(-1)
    end
  end

  describe "Create" do
    it "creates a bucket" do
      expect do
        repo.create_bucket(params)
      end.to change { repo.all_buckets.count }.by(1)
    end

    it "creates an item" do
      expect do
        params[:done] = true
        repo.create_item(params)
      end.to change { repo.all_items.count }.by(1)
    end
  end

  describe "Search" do
    it "searches for available buckets" do
      create_list(:bucket, 10, created_by: user.id)

      datum = repo.find_bucket(
        rand(repo.all_buckets.first.id..repo.all_buckets.last.id)).name
      page_params = {
        limit: 20,
        page: 0
      }

      expect(repo.all_buckets).
        to include(repo.search(datum, page_params).first)
    end
  end
end
