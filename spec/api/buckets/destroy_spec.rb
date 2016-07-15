require "rails_helper"

RSpec.describe "DELETE /bucketlists/:id", type: :request do
  let(:user) { create(:user) }
  let!(:bucket) { create(:bucket, created_by: user.id) }
  let(:id) { bucket.id }

  let!(:req) { delete "/bucketlists/#{id}", {}, auth_headers }
  subject { response }

  context "when the bucket exists" do
    it_behaves_like "api_response", 204
  end

  context "when the bucket does not exist" do
    let(:id) { bucket.id.next }

    it_behaves_like "api_response", 404, "errors"
    it_behaves_like "response_message", "errors", "no_resource", "Bucket"
  end
end
