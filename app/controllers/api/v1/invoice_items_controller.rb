class Api::V1::InvoiceItemsController < ApplicationController
  respond_to :json

  def index
    respond_with InvoiceItem.all
  end

  def show
    respond_with InvoiceItem.find_by(id: params[:id])
  end

  def find
    respond_with InvoiceItem.find_by(finder_params)
  end

  def find_all
    respond_with InvoiceItem.where(finder_params)
  end

  def random
    respond_with InvoiceItem.all.sample
  end

  private

    def finder_params
      params.permit(:id,
                    :item_id,
                    :invoice_id,
                    :quantity,
                    :unit_price)
    end
end
