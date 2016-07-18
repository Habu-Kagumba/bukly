require "rails_helper"

RSpec.describe "GET /bucketlists/:bucket_id/items/:id", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:bucket_item, created_by: user.id) }
  let(:bucket_id) { item.bucket.id }
  let(:id) { item.id }

  let!(:req) { get "/bucketlists/#{bucket_id}/items/#{id}", {}, auth_headers }
  subject { response }

  context "when the user retrieves a bucketlist item" do
    it_behaves_like "api_response", 200, "item"
    it "returns the requested bucketlist item" do
      expect(json.fetch("name")).to eql item.name
    end
  end

  context "when the user retrieves a non-existent bucketlist item" do
    let(:id) { item.id.next }

    it_behaves_like "api_response", 404, "errors"
    it_behaves_like "response_message", "errors", "no_resource", "Item"
  end
end
