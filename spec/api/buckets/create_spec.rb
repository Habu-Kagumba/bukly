require "rails_helper"

RSpec.describe "POST /bucketlists", type: :request do
  let(:user) { create(:user) }
  let(:bucket) { create(:bucket) }
  let(:attrs) { attributes_for(:bucket) }
  let(:header) { auth_headers }

  let!(:req) { post "/bucketlists", attrs, header }
  subject { response }

  context "when a bucket has valid attributes" do
    it_behaves_like "api_response", 201, "bucket"
  end

  context "when a bucket has invalid attributes" do
    let(:attrs) { attributes_for(:invalid_bucket) }

    it_behaves_like "api_response", 422, "errors"
  end

  context "when an authorization token is not passed" do
    let(:header) { headers }
    it_behaves_like "api_response", 401, "errors"
  end
end
