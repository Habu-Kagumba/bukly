require "rails_helper"

RSpec.describe ApiConstraint do
  let(:request) { double :request }

  describe "#matches?" do
    let(:version) { 1 }

    subject(:constraint) { described_class.new(version: version) }

    def header_for_version(version)
      "version=#{version}"
    end

    it "matches requests including the versioned vendor mime type" do
      headers = { accept: header_for_version(version) }
      allow(request).to receive(:headers).and_return(headers)

      expect(constraint.matches?(request)).to be_truthy
    end

    it "does not match requests for other versions" do
      headers = { accept: header_for_version(version + 1) }
      allow(request).to receive(:headers).and_return(headers)

      expect(constraint.matches?(request)).to be_falsey
    end
  end
end
