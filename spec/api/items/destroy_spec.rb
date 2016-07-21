require "rails_helper"

RSpec.describe "DELETE /bucketlists/:id", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:bucket_item, created_by: user.id) }
  let(:bucket_id) { item.bucket.id }
  let(:id) { item.id }
  let(:attrs) { attributes_for(:bucket_item, created_by: user.id) }
  let(:header) { auth_headers }

  let!(:req) do
    delete "/bucketlists/#{bucket_id}/items/#{id}", attrs, header
  end
  subject { response }

  context "when the item exists" do
    it_behaves_like "api_response", 204
  end

  context "when the item doesn't exist" do
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
