require "rails_helper"

RSpec.describe "POST /bucketlists/:id/items" do
  let(:user) { create(:user) }
  let(:item) { create(:bucket_item, created_by: user.id) }
  let(:bucket_id) { item.bucket.id }
  let(:attrs) { attributes_for(:bucket_item, created_by: user.id) }
  let(:header) { auth_headers }

  let!(:req) { post "/bucketlists/#{bucket_id}/items", attrs, header }
  subject { response }

  context "when an item has valid attributes" do
    it_behaves_like "api_response", 201, "item"
  end

  context "when an item has invalid attributes" do
    let(:attrs) { attributes_for(:invalid_item, created_by: user.id) }

    it_behaves_like "api_response", 422, "errors"
  end

  context "when an authorization token is not passed" do
    let(:header) { headers }
    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "missing_token"
  end
end
