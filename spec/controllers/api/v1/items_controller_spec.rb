require "rails_helper"

RSpec.describe Api::V1::ItemsController, type: :controller do
  let(:item) { create(:bucket_item) }
  let(:valid_attributes) { attributes_for(:bucket_item) }
  let(:invalid_attributes) { attributes_for(:invalid_item) }
  let(:headers) { { accept: "application/vnd.bukly+json; version=1" } }

  describe "Get all items" do
    context "when all items are retrieved" do
      it "returns all items" do
        allow(request).to receive(:headers).and_return(headers)
        test_item = create(:bucket_item)
        param = { bucket_id: test_item.bucket.id }
        get :index, param

        expect(response).to be_success
        expect(json.first.fetch("name")).to eql test_item.name
      end
    end

    context "when there are no items" do
      it "returns a not found error" do
        allow(request).to receive(:headers).and_return(headers)
        test_bucket = create(:empty_bucket)
        param = { bucket_id: test_bucket.id }
        get :index, param

        expect(response).to be_success
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resources("items")
      end
    end
  end

  describe "Show an item" do
    let!(:show_item) { create(:bucket_item) }

    context "when a user requests for an item" do
      it "returns the requested item" do
        allow(request).to receive(:headers).and_return(headers)
        param = { bucket_id: show_item.bucket.id, id: show_item.id }
        get :show, param

        expect(response).to be_success
        expect(json).to match_response_schema("item")
        expect(json.fetch("name")).to eql show_item.name
      end
    end

    context "when a user requests for non-existent item" do
      it "returns a not found error" do
        allow(request).to receive(:headers).and_return(headers)
        param = { bucket_id: show_item.bucket.id, id: show_item.name }
        get :show, param

        expect(response).to be_not_found
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resource("Item")
      end
    end
  end

  describe "Create item" do
    let!(:create_bucket) { create(:empty_bucket) }

    context "when an item is created with valid attributes" do
      it "creates the item successfully" do
        allow(request).to receive(:headers).and_return(headers)
        param = valid_attributes.merge(bucket_id: create_bucket.id)
        expect do
          post :create, param
        end.to change { Item.count }.by(1)
        expect(response).to have_http_status 201
        expect(json).to match_response_schema("item")
        expect(json.fetch("name")).to eql param[:name]
      end
    end

    context "when an item is created with invalid attributes" do
      it "should return avalidation error" do
        allow(request).to receive(:headers).and_return(headers)
        param = invalid_attributes.merge(bucket_id: create_bucket.id)
        expect do
          post :create, param
        end.not_to change { Item.count }
        expect(json.fetch("errors")).to include "Name can't be blank"
      end
    end
  end

  describe "Update item" do
    let!(:update_item) { create(:bucket_item) }

    context "when an item is updated with invalid attributes" do
      it "updates the item successfully" do
        allow(request).to receive(:headers).and_return(headers)
        param = invalid_attributes.merge(
          bucket_id: update_item.bucket.id,
          id: update_item.id
        )
        put :update, param

        expect(response).to have_http_status 422
        expect(json.fetch("errors")).to include "Name can't be blank"
      end
    end

    context "when the item doesn't exists" do
      it "returns a not found error" do
        allow(request).to receive(:headers).and_return(headers)
        param = valid_attributes.merge(
          bucket_id: update_item.bucket.id,
          id: update_item.name
        )
        put :update, param

        expect(response).to be_not_found
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resource("Item")
      end
    end

    context "when an item is updated with valid attributes" do
      it "updates the item successsfully" do
        allow(request).to receive(:headers).and_return(headers)
        param = {
          bucket_id: update_item.bucket.id,
          id: update_item.id,
          name: valid_attributes[:name]
        }

        put :update, param

        expect(response).to have_http_status 204
        expect(Item.find(update_item.id).name).
          to eql valid_attributes[:name]
      end
    end
  end

  describe "Delete item" do
    let!(:delete_item) { create(:bucket_item) }

    context "when the item exists" do
      it "deletes the item successfully" do
        allow(request).to receive(:headers).and_return(headers)
        expect do
          param = {
            bucket_id: delete_item.bucket.id,
            id: delete_item.id
          }
          delete :destroy, param
        end.to change { Item.count }.by(-1)
      end
    end

    context "when the item doesn't exist" do
      it "returns a not found error" do
        allow(request).to receive(:headers).and_return(headers)
        param = {
          bucket_id: delete_item.bucket.id,
          id: delete_item.name
        }
        delete :destroy, param

        expect(response).to have_http_status 404
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resource("Item")
      end
    end
  end
end
