require "rails_helper"

RSpec.describe PaginationService, type: :controller do
  def service(request)
    described_class.new(request, Bucket.count)
  end

  def custom_req(param)
    OpenStruct.new param
  end

  describe "Default pagination parameters" do
    it "returns the default limit and offset" do
      param = {
        "original_url" => "localhost:3000/bucketlists",
        "query_parameters" => {}
      }
      expected_result = { limit: 20, offset: 0 }

      expect(service(custom_req(param)).paginate_params).to eql expected_result
    end
  end

  describe "Calculated pagination parameter" do
    it "calculates the limit and offset" do
      param = {
        "original_url" => "localhost:3000/bucketlists?page=2&limit=100",
        "query_parameters" => { page: 2, limit: 100 }
      }
      expected_result = { limit: 100, offset: 100 }

      expect(service(custom_req(param)).paginate_params).to eql expected_result
    end
  end

  describe "Pagination headers" do
    it "set the pagination meta as headers" do
      param = {
        "original_url" => "localhost:3000/bucketlists?page=1",
        "query_parameters" => { page: 1 }
      }
      expected_result = "<localhost:3000/bucketlists?page=1>; rel=\"first\","\
      " <localhost:3000/bucketlists?page=1>; rel=\"last\""

      expect(service(custom_req(param)).set_pagination_headers).
        to eql expected_result
    end
  end
end
