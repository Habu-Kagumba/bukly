class ApplicationController < ActionController::API
  include ActionController::MimeResponds, ExceptionHandlers, JsonResponse

  before_action :authenticate_request, except: :not_found
  attr_reader :current_user, :token

  def not_found
    render json: { errors: ExceptionMessages::Messages.not_found },
           status: :not_found
  end

  private

  def authenticate_request
    auth_params = authorize_service.authorize
    @current_user = auth_params[:user]
    @token = auth_params[:token]

    if @current_user.invalid_tokens.pluck(:token).include? @token
      raise ExceptionHandlers::ExpiredSignatureError,
            ExceptionMessages::Messages.expired_sig
    end
  end

  def authorize_service
    ApiAuthorizeService.new(request.headers)
  end
end
