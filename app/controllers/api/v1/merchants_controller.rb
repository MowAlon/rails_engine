class Api::V1::MerchantsController < Api::V1::BaseController

  def object_type
    Merchant
  end

  def items
    respond_with Item.where(merchant_id: params[:id]).order(:id)
  end

  def invoices
    respond_with Invoice.where(merchant_id: params[:id]).order(:id)
  end

  private

    def finder_params
      params.permit(:id,
                    :name)
    end
end
