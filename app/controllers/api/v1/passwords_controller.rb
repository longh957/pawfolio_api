module Api
  module V1
    class PasswordsController < ApplicationController
      skip_before_action :authenticate_user
      def create
        set_user_by_email
        @user.generate_password_reset_token!
        if @user.password_reset_token.present?
          render json: { message: 'ok' }, status: :ok
        else
          #TODO change exceptions to be more helpful
          raise NotAuthorizedException
        end
      rescue NotAuthorizedException
        render json: { error: 'Bad Request' }, status: :bad_request
      end

      def update
        raise NotAuthorizedException if update_params[:password].blank?
        set_user_by_token
        if @user.update(password: update_params[:password], password_reset_token: nil)
          render json: { message: 'ok' }, status: :ok
        else
          raise NotAuthorizedException
        end
      rescue NotAuthroizedException
        render json: { error: user.errors.full_messages || 'Not Authorized' }, status: :unprocessiable_entity
      end

      private

      def create_params
        params.permit(:email)
      end

      def update_params
        params.permit(:password, :id)
      end

      def set_user_by_token
        @user = User.find_by(password_reset_token: update_params[:id])
        raise NotAuthorizedException unless @user
      end

      def set_user_by_email
        @user = User.find_by(create_params)
        raise NotAuthorizedException unless @user
      end
    end
  end
end
