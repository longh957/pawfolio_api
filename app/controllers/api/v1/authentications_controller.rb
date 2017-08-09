module Api
  module V1
    class AuthenticationsController < ApplicationController
      skip_before_action :authenticate_user
      def create
        token_command = AuthenticateUserCommand.call(*create_params.values)

        if token_command.success?
          render json: { token: token_command.result }
        else
          render json: { error: token_command.errors }, status: :unauthorized
        end
      end

      private

      def create_params
        params.permit(:user, :password)
      end
    end
  end
end
