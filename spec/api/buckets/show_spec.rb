require "rails_helper"

RSpec.describe "GET /bucketlists/:id", type: :request do
  let(:user) { create(:user) }
  let!(:bucket) { create(:bucket, created_by: user.id) }
  let(:id) { bucket.id }
  let(:header) { auth_headers }

  let!(:req) { get "/bucketlists/#{id}", {}, header }
  subject { response }

  context "when the user retrieves a bucketlist" do
    it_behaves_like "api_response", 200, "bucket"
    it "returns the requested bucketlist" do
      expect(json.fetch("name")).to eql bucket.name
    end
  end

  context "when the user retrieves a non-existent bucketlist" do
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
