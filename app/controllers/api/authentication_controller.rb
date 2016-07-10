module Api
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request, only: :login

    def login
      data = {
        message: ExceptionMessages::Messages.logged_in,
        auth_token: auth_service.login
      }
      render_json(data)
    end

    def logout
      current_user.invalid_tokens.create!(token: token)
      @current_user = nil

      data = { message: ExceptionMessages::Messages.logged_out }
      render_json(data)
    end

    private

    def auth_service
      AuthenticationService.new(params[:email], params[:password])
    end
  end
end
