# frozen_string_literal: true

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [ :login, :register ]

      def login
        auth_result = AuthenticationService.login(params[:email], params[:password])

        if auth_result
          render json: auth_result, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def register
        user = User.new(user_params)

        if user.save
          auth_result = AuthenticationService.login(user.email, user.password)
          render json: auth_result, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def me
        render json: {
          user: {
            id: @current_user.id,
            email: @current_user.email,
            first_name: @current_user.first_name,
            last_name: @current_user.last_name
          }
        }
      end

      private

      def user_params
        params.permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
