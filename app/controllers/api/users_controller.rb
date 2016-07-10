module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_request

    def create
      data = {
        message: ExceptionMessages::Messages.create_user,
        auth_token: auth_service.create_user
      }
      render_json(data, :created)
    end

    private

    def user_params
      params.permit(
        :email,
        :password
      )
    end

    def auth_service
      AuthenticationService.new(user_params["email"], user_params["password"])
    end
  end
end
