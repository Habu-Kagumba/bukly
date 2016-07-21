require "rails_helper"

RSpec.describe "PUT /bucketlists/:bucket_id/items/:id", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:bucket_item, created_by: user.id) }
  let(:bucket_id) { item.bucket.id }
  let(:id) { item.id }
  let(:attrs) { attributes_for(:bucket_item, created_by: user.id) }
  let(:header) { auth_headers }

  let!(:req) do
    put "/bucketlists/#{bucket_id}/items/#{id}", attrs, header
  end
  subject { response }

  context "when an item has valid attributes" do
    it_behaves_like "api_response", 204
    it "updates the bucketlist" do
      expect(Item.find(id).name).to eql attrs[:name]
    end
  end

  context "when an item has invalid attributes" do
    let(:attrs) { attributes_for(:invalid_item, created_by: user.id) }

    it_behaves_like "api_response", 422, "errors"
  end

  context "when an item doesn't exist" do
    let(:id) { item.id.next }

    it_behaves_like "api_response", 404, "errors"
    it_behaves_like "response_message", "errors", "no_resource", "Item"
  end

  context "when an authorization token is not passed" do
    let(:header) { headers }
    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "missing_token"
  end
end
