require "rails_helper"

RSpec.describe "PUT /bucketlists/:id", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket, created_by: user.id) }
  let(:id) { bucket.id }
  let(:attrs) { attributes_for(:bucket) }

  let!(:req) { put "/bucketlists/#{id}", attrs, auth_headers }
  subject { response }

  context "when a bucket has valid attributes" do
    it_behaves_like "api_response", 204
    it "updates the bucketlist" do
      expect(Bucket.find(id).name).to eql attrs[:name]
    end
  end

  context "when a bucket has invalid attributes" do
    let(:attrs) { attributes_for(:invalid_bucket) }

    it_behaves_like "api_response", 422, "errors"
  end

  context "when a bucket desn't exist" do
    let(:id) { bucket.id.next }

    it_behaves_like "api_response", 404, "errors"
    it_behaves_like "response_message", "errors", "no_resource", "Bucket"
  end
end
