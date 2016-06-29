module Api
  module V1
    class BucketsController < ApplicationController
      def index
        render_json(service.buckets(params))
      end

      def show
        render_json(get_bucket)
      end

      def create
        render_json(service.create_bucket(bucket_params), "created")
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
        ResourcesService.new
      end

      def bucket_params
        params.permit(:name)
      end

      def get_bucket
        service.bucket(params[:id])
      end
    end
  end
end
