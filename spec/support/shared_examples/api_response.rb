RSpec.shared_examples "api_response" do |status, schema|
  its(:status) { should eq status }
  its(:body)   { should match_schema schema } if schema
end
