class ApplicationController < ActionController::API
  include ActionController::MimeResponds, ExceptionHandlers, JsonResponse

  before_action :authenticate_request, except: :not_found
  attr_reader :current_user

  def not_found
    render json: { errors: ExceptionMessages::Messages.not_found },
           status: :not_found
  end

  private

  def authenticate_request
    @current_user = authorize_service.authorize
  end

  def authorize_service
    ApiAuthorizeService.new(request.headers)
  end
end
