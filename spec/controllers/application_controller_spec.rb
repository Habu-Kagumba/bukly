require "rails_helper"

RSpec.describe ApplicationController, type: :request do
	let(:headers) { { ACCEPT: "application/vnd.bukly+json; version=1" } }

	describe "Undefined endpoints" do
		context "when a user visits a non-existing endpoint" do
			it "responds with a 404 - not found error" do
        route = FFaker::Lorem.word
				allow(request).to receive(:headers).and_return(headers)
				get "/#{route}"

        expect(response).to have_http_status 404
        expect(json.fetch("errors")).to eql "Route not found"
			end
		end
	end
end
