require "rails_helper"

RSpec.describe "GET /bucketlists/:bucket_id/items", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:bucket_item, created_by: user.id) }
  let(:bucket_id) { item.bucket.id }
  let(:header) { auth_headers }

  let!(:req) { get "/bucketlists/#{bucket_id}/items", {}, header }
  subject { response }

  context "when the user retrieves items" do
    it_behaves_like "api_response", 200
    it "returns all buckets" do
      expect(json.to_json).
        to eql ActiveModelSerializers::SerializableResource.new(
          Item.where(bucket_id: bucket_id)).to_json
    end
  end

  context "when the user's bucketlist doesn't have any items" do
    let(:bucket) { create(:empty_bucket, created_by: user.id) }
    let(:bucket_id) { bucket.id }

    it_behaves_like "api_response", 200, "errors"
    it_behaves_like "response_message", "errors", "no_resources", "items"
  end

  context "when an authorization token is not passed" do
    let(:header) { headers }
    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "missing_token"
  end
end
