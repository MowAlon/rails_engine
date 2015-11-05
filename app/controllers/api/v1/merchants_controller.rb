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

  def most_revenue
    respond_with Merchant.most_revenue(params[:quantity].to_i)
  end

  def most_items
    respond_with Merchant.most_items_sold(params[:quantity].to_i)
  end

  def revenue
    respond_with Merchant.revenue_by_date(params[:date])
  end

  def single_merchant_revenue
    respond_with Merchant.single_merchant_revenue(params[:id], params[:date])
  end

  def favorite_customer
    respond_with Merchant.favorite_customer(params[:id])
  end

  def customers_with_pending_invoices
    respond_with Merchant.customers_with_pending_invoices(params[:id])
  end

  private

    def finder_params
      params.permit(:id,
                    :name,
                    :created_at,
                    :updated_at)
    end
end
