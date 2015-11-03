class Api::V1::InvoicesController < ApplicationController
  respond_to :json

  def index
    respond_with Invoice.all
  end

  def show
    respond_with Invoice.find_by(id: params[:id])
  end

  def find
    respond_with Invoice.find_by(finder_params)
  end

  def find_all
    respond_with Invoice.where(finder_params)
  end

  def random
    respond_with Invoice.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :customer_id,
                    :merchant_id,
                    :status)
    end
end
