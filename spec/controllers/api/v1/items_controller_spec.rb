require "rails_helper"

RSpec.describe Api::V1::ItemsController, type: :controller do
  let(:user) { create(:logged_in_user) }
  let(:auth_token) { token(user) }
  let(:item) { create(:bucket_item) }
  let(:valid_attributes) { attributes_for(:bucket_item) }
  let(:invalid_attributes) { attributes_for(:invalid_item) }
  let(:headers) do
    {
      accept: "application/vnd.bukly+json; version=1",
      authorization: auth_token
    }
  end

  before do
    request.headers["accept"] = headers.fetch(:accept)
    request.headers["authorization"] = headers.fetch(:authorization)
  end

  describe "Get all items" do
    context "when all items are retrieved" do
      it "returns all items" do
        test_bucket = create(:empty_bucket, created_by: user.id)
        test_item = create(:item, bucket_id: test_bucket.id)
        param = { bucket_id: test_item.bucket.id }
        get :index, param

        expect(response).to be_success
        expect(json.first.fetch("name")).to eql test_item.name
      end
    end

    context "when there are no items" do
      it "returns a not found error" do
        test_bucket = create(:empty_bucket, created_by: user.id)
        param = { bucket_id: test_bucket.id }
        get :index, param

        expect(response).to be_success
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resources("items")
      end
    end
  end

  describe "Show an item" do
    let!(:show_bucket) { create(:empty_bucket, created_by: user.id) }
    let!(:show_item) { create(:item, bucket_id: show_bucket.id) }

    context "when a user requests for an item" do
      it "returns the requested item" do
        param = { bucket_id: show_item.bucket.id, id: show_item.id }
        get :show, param

        expect(response).to be_success
        expect(json).to match_response_schema("item")
        expect(json.fetch("name")).to eql show_item.name
      end
    end

    context "when a user requests for non-existent item" do
      it "returns a not found error" do
        param = { bucket_id: show_item.bucket.id, id: show_item.name }
        get :show, param

        expect(response).to be_not_found
        expect(json.fetch("errors")).
          to eql ExceptionMessages::Messages.no_resource("Item")
      end
    end
  end

  describe "Create item" do
    let!(:create_bucket) { create(:empty_bucket, created_by: user.id) }

    context "when an item is created with valid attributes" do
      it "creates the item successfully" do
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
        param = invalid_attributes.merge(bucket_id: create_bucket.id)
        expect do
          post :create, param
        end.not_to change { Item.count }
        expect(json.fetch("errors")).to include "Name can't be blank"
      end
    end
  end

  describe "Update item" do
    let!(:update_bucket) { create(:empty_bucket, created_by: user.id) }
    let!(:update_item) { create(:item, bucket_id: update_bucket.id) }

    context "when an item is updated with invalid attributes" do
      it "updates the item successfully" do
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
    let!(:delete_bucket) { create(:empty_bucket, created_by: user.id) }
    let!(:delete_item) { create(:item, bucket_id: delete_bucket.id) }

    context "when the item exists" do
      it "deletes the item successfully" do
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
