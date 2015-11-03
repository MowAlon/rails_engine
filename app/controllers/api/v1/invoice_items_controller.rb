class Api::V1::InvoiceItemsController < Api::V1::BaseController

  def object_type
    InvoiceItem
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
