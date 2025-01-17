# frozen_string_literal: true

class Api::V1::SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
    render json: @suppliers
  end
end
