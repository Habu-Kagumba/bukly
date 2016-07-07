require "rails_helper"

RSpec.describe ResourcesService do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket, created_by: user.id) }
  let(:params_bucket) { attributes_for(:bucket, created_by: user.id) }
  let(:params_item) { attributes_for(:item) }
  let(:invalid_bucket) { attributes_for(:invalid_bucket, created_by: user.id) }
  let(:invalid_item) { attributes_for(:invalid_item) }
  subject(:service_bucket) { described_class.new(user) }
  subject(:service_item) { described_class.new(user, bucket.id) }

  describe "Get bucket resources" do
    it "gets the requested resource" do
      expect(service_bucket.bucket(bucket.id)).to eql bucket
    end

    it "raises an error if resources not found" do
      expect do
        service_bucket.bucket(bucket.name)
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it "gets all the requested resources" do
      create_list(:bucket, 10, created_by: user.id)
      expect(service_bucket.buckets({}).to_json).to eql Bucket.all.to_json
    end

    it "returns an error when resources don't exist" do
      expect do
        service_bucket.buckets({})
      end.to raise_error ExceptionHandlers::NoBucketsError
    end
  end

  describe "Get Item resources" do
    let(:bucket) { create(:bucket, created_by: user.id) }

    it "gets the requested resource" do
      expect(service_item.item(bucket.items.first.id)).to eql bucket.items.first
    end

    it "raises an error if resources not found" do
      expect do
        service_item.item(bucket.name)
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it "gets all the requested resources" do
      create_list(:bucket, 10, created_by: user.id)
      expect(service_item.items.to_json).
        to eql Item.where(bucket_id: bucket.id).to_json
    end

    it "returns an error when resources don't exist" do
      delete_bucket = create(:empty_bucket, created_by: user.id)
      delete_service = described_class.new(user, delete_bucket.id)
      expect do
        delete_service.items
      end.to raise_error ExceptionHandlers::NoBucketsError
    end
  end

  describe "Create bucket resources" do
    it "creates a bucket successfully" do
      expect do
        service_bucket.create_bucket(params_bucket)
      end.to change { Bucket.count }.by(1)
    end

    it "raises error if bucket has invalid attributes" do
      expect do
        service_bucket.create_bucket(invalid_bucket)
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "Create Item resources" do
    it "creates an item successfully" do
      expect do
        service_item.create_item(params_item)
      end.to change { service_item.items.count }.by(1)
    end

    it "raises error if item has invalid attributes" do
      expect do
        service_item.create_item(invalid_item)
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "Update Bucket resources" do
    it "updates a bucket successfully" do
      service_bucket.update_bucket(bucket, params_bucket)
      expect(service_bucket.bucket(bucket.id).name).to eql params_bucket[:name]
    end

    it "raises error if bucket is not found" do
      expect do
        service_bucket.update_bucket(
          build(:bucket, created_by: user.id),
          params_bucket
        )
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it "raises error if bucket has invalid attributes" do
      expect do
        service_bucket.update_bucket(bucket, invalid_bucket)
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "Update Item resources" do
    let(:item) { bucket.items.first }

    it "updates an item successfully" do
      service_item.update_item(item.id, params_item)
      expect(service_item.item(item.id).name).to eql params_item[:name]
    end

    it "raises error if item is not found" do
      expect do
        service_item.update_item(item.name, params_item)
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it "raises error if item has invalid attributes" do
      expect do
        service_item.update_item(item.id, invalid_item)
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "Destroy bucket resources" do
    let!(:create_bucket) { create(:bucket, created_by: user.id) }
    let!(:build_bucket) { build(:bucket, created_by: user.id) }

    it "deletes a bucket successfully" do
      expect do
        service_bucket.destroy_bucket(create_bucket)
      end.to change { Bucket.count }.by(-1)
    end

    it "raises error if bucket is not found" do
      expect do
        service_bucket.destroy_bucket(build_bucket)
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "Destroy Item resources" do
    let!(:item) { bucket.items.first }

    it "destroys an item successfully" do
      expect do
        service_item.destroy_item(item.id)
      end.to change { Item.count }.by(-1)
    end

    it "raises error if item is not found" do
      expect do
        service_item.destroy_item(item.name)
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
