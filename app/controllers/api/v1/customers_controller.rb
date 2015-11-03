class Api::V1::CustomersController < ApplicationController
  respond_to :json

  def index
    respond_with Customer.all
  end

  def show
    respond_with Customer.find_by(id: params[:id])
  end

  def find
    respond_with Customer.find_by(finder_params)
  end

  def find_all
    respond_with Customer.where(finder_params)
  end

  def random
    respond_with Customer.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :first_name,
                    :last_name)
    end
end
