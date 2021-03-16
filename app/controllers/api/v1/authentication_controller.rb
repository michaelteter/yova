module Api
  module V1
    class AuthenticationController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        begin
          params.require(:username)
          params.require(:password)
          params.permit(:username, :password)
        rescue ActionController::ParameterMissing
          render plain: 'missing param', status: :unprocessable_entity
          return
        end

        token = AuthenticationService.login(username: params[:username],
                                            password: params[:password])

        render json: { token: token }, status: :created
      end
    end
  end
end
