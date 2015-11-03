class Api::V1::ItemsController < ApplicationController
  respond_to :json

  def index
    respond_with Item.all
  end

  def show
    respond_with Item.find_by(id: params[:id])
  end

  def find
    respond_with Item.find_by(finder_params)
  end

  def find_all
    respond_with Item.where(finder_params)
  end

  def random
    respond_with Item.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :name,
                    :description,
                    :unit_price,
                    :merchant_id)
    end
end
