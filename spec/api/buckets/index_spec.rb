require "rails_helper"

RSpec.describe "GET /bucketlists", type: :request do
  let(:user) { create(:user) }
  let(:length) { 10 }
  let!(:bucket) { create_list(:bucket, length, created_by: user.id) }

  let!(:req) { get "/bucketlists", {}, auth_headers }
  subject { response }

  context "when the user has 10 bucketlists" do
    it_behaves_like "api_response", 200
    it "returns all buckets" do
      expect(json.length).to eql length
    end
  end

  context "when the user doesn't have any bucketlists" do
    let(:length) { 0 }

    it_behaves_like "api_response", 200, "errors"
    it_behaves_like "response_message", "errors", "no_resources", "bucketlists"
  end
end
