require "rails_helper"

RSpec.describe "DELETE /bucketlists/:id", type: :request do
  let(:user) { create(:user) }
  let!(:bucket) { create(:bucket, created_by: user.id) }
  let(:id) { bucket.id }
  let(:header) { auth_headers }

  let!(:req) { delete "/bucketlists/#{id}", {}, header }
  subject { response }

  context "when the bucket exists" do
    it_behaves_like "api_response", 204
  end

  context "when the bucket does not exist" do
    let(:id) { bucket.id.next }

    it_behaves_like "api_response", 404, "errors"
    it_behaves_like "response_message", "errors", "no_resource", "Bucket"
  end

  context "when an authorization token is not passed" do
    let(:header) { headers }
    it_behaves_like "api_response", 401, "errors"
    it_behaves_like "response_message", "errors", "missing_token"
  end
end
