module Api
  module V1
    class PasswordsController < ApplicationController
      skip_before_action :authenticate_user
      def create
        user = User.find_by(create_params)
        user.generate_password_reset_token!
        if user.password_reset_token.present?
          render json: { message: 'ok' }, status: :ok
        else
          render json: { error: 'Bad Request' }, status: :bad_request
        end
      end

      def update
        #TODO raise error if token missin
        user = User.find_by(password_reset_token: update_params[:id])
        if user.update(password: update_params[:password])
          user.update(password_reset_token: nil)
          render json: { message: 'ok' }, status: :ok
        else
          render json: { error: user.errors.full_messages }, status: :unprocessiable_entity
        end
      end

      private

      def create_params
        params.permit(:email)
      end

      def update_params
        params.permit(:password, :id)
      end
    end
  end
end
