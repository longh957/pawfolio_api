module Api
  module V1
    class PasswordsController < ApplicationController
      skip_before_action :authenticate_user
      def create
        user = User.find_by_email(create_params[:email])
        user.generate_password_reset_token!
      end
      def update
      end

      private

      def create_params
        params.permit(:email)
      end
    end
  end
end
