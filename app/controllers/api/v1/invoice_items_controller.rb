class Api::V1::InvoiceItemsController < Api::V1::BaseController

  def object_type
    InvoiceItem
  end

  def invoice
    respond_with current_invoice_item.invoice
  end

  def item
    respond_with current_invoice_item.item
  end

  private

    def current_invoice_item
      InvoiceItem.find_by(id: params[:id])
    end

    def finder_params
      params.permit(:id,
                    :item_id,
                    :invoice_id,
                    :quantity,
                    :unit_price,
                    :created_at,
                    :updated_at)
    end
end
