module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render_json(service.items)
      end

      def show
        render_json(get_item)
      end

      def create
        render_json(service.create_item(item_params), :created)
      end

      def update
        service.update_item(get_item.id, item_params)
        head :no_content
      end

      def destroy
        service.destroy_item(get_item.id)
        head :no_content
      end

      private

      def get_item
        service.item(params[:id])
      end

      def item_params
        params.permit(:name, :done)
      end

      def service
        ResourcesService.new(current_user, params[:bucket_id], request)
      end
    end
  end
end
