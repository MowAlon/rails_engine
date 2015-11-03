class Api::V1::BaseController < ApplicationController
  respond_to :json

  def index
    respond_with object_type.all
  end

  def show
    respond_with object_type.find_by(id: params[:id])
  end

  def find
    respond_with object_type.find_by(finder_params)
  end

  def find_all
    respond_with object_type.where(finder_params)
  end

  def random
    respond_with object_type.all.sample
  end

end
