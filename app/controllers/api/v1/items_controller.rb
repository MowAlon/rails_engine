class Api::V1::ItemsController < Api::V1::BaseController

  def object_type
    Item
  end

  def invoice_items
    respond_with InvoiceItem.where(item_id: params[:id])
  end

  def merchant
    respond_with current_item.merchant
  end

  def most_revenue
    respond_with Item.most_revenue(params[:quantity].to_i)
  end

  def most_items
    respond_with Item.most_items_sold(params[:quantity].to_i)
  end

  def best_day
    respond_with Item.best_day(params[:id])
  end


  private

    def current_item
      Item.find(params[:id])
    end

    def finder_params
      params.permit(:id,
                    :name,
                    :description,
                    :unit_price,
                    :merchant_id,
                    :created_at,
                    :updated_at)
    end
end
