module Api
  module V1
    class BucketsController < ApplicationController
      after_filter only: [:index] { set_pagination_headers }

      def index
        render_json(service.buckets)
      end

      def show
        render_json(get_bucket)
      end

      def create
        render_json(service.create_bucket(bucket_params), :created)
      end

      def update
        service.update_bucket(get_bucket, bucket_params)
        head :no_content
      end

      def destroy
        service.destroy_bucket(get_bucket)
        head :no_content
      end

      private

      def service
        ResourcesService.new(current_user, nil, request)
      end

      def bucket_params
        params.permit(:name)
      end

      def get_bucket
        service.bucket(params[:id])
      end

      def set_pagination_headers
        headers["Link"] = service.page_headers
      end
    end
  end
end
