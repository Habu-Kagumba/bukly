class ApplicationController < ActionController::API
  include ActionController::MimeResponds, ExceptionHandlers, JsonResponse

  def not_found
    render json: { errors: "Route not found" }, status: :not_found
  end
end
