class Api::V1::MerchantsController < ApplicationController
  respond_to :json

  def index
    respond_with Merchant.all
  end

  def show
    respond_with Merchant.find_by(id: params[:id])
  end

  def find
    respond_with Merchant.find_by(finder_params)
  end

  def find_all
    respond_with Merchant.where(finder_params)
  end

  def random
    respond_with Merchant.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :name)
    end
end
