class Api::V1::TransactionsController < ApplicationController
  respond_to :json

  def index
    respond_with Transaction.all
  end

  def show
    respond_with Transaction.find_by(id: params[:id])
  end

  def find
    respond_with Transaction.find_by(finder_params)
  end

  def find_all
    respond_with Transaction.where(finder_params)
  end

  def random
    respond_with Transaction.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :invoice_id,
                    :credit_card_number,
                    :credit_card_expiration_date,
                    :result)
    end
end
