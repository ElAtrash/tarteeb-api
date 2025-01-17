# frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  def index
    @products = Product.all
    render json: @products
  end
end
