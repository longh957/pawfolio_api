module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :authenticate_user, only: [:create]

      def create
        user = User.create(create_params)
        if user && user.persisted?
          render json: { message: 'Success' }, status: :created
        else
          render json: { error: user.errors.full_messages }, status: :bad_request
        end
      end

      def update
        if @current_user.update(update_params)
          render json: { message: 'Success' }, status: :accepted
        else
          render json: { error: @current_user.errors.full_messages }, stautus: :unprocessable_entity
        end
      end

      def destroy
        @current_user.delete if @current_user.authenticate(delete_params[:password])
        if @current_user.persisted?
          render json: { error: 'Bad Request' }, status: :bad_request
        else
          render json: { message: 'Success' }, status: :accepted
        end
      end

      private

      def create_params
        params.permit(:name, :email, :password)
      end

      def update_params
        params.permit(:name, :email)
      end

      def delete_params
        params.permit(:password)
      end
    end
  end
end
