module Api
  module V1
    class PetsController < ApplicationController
      before_action :set_pet, only: [:show, :update, :destroy]
      def index
        @pets = @current_user.pets
        render json: @pets
      end

      def show
        if @pet
          render json: @pet
        else
          render json: { pet: 'No Pets' }
        end
      end

      def create
        args = { user: @current_user }.merge(pet_params)
        @pet = Pet.create(args)
        if @pet.persisted?
          render json: @pet
        else
          render json: @pet.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        @pet.update(pet_params)
        if @pet.persisted?
          render json: @pet
        else
          render json: @pet.errors.full_messages, status: :unprocessable_entity
        end
      end

      def destroy
        @pet.destroy
        render json: { message: 'ok' }, status: :ok
      end

      private

      def set_pet
        @pet = Pet.find_by(user: @current_user, id: params[:id])
        render json: { pet: 'Not Found' } and return unless @pet
      end

      def pet_params
        params.permit(:name, :dob)
      end
    end
  end
end
