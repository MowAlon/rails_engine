class Api::V1::ItemsController < Api::V1::BaseController

  def object_type
    Item
  end

  def invoice_items
    respond_with InvoiceItem.where(item_id: params[:id])
  end

  def merchant
    respond_with current_item.merchant_id
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
                    :merchant_id)
    end
end
