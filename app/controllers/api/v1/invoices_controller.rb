class Api::V1::InvoicesController < Api::V1::BaseController

  def object_type
    Invoice
  end

  def transactions
    respond_with Transaction.where(invoice_id: params[:id]).order(:id)
  end

  def invoice_items
    respond_with InvoiceItem.where(invoice_id: params[:id]).order(:id)
  end

  def items
    respond_with current_invoice.items
  end

  def customer
    respond_with current_invoice.customer
  end

  def merchant
    respond_with current_invoice.merchant
  end

  private

  def current_invoice
    Invoice.find_by(id: params[:id])
  end

    def finder_params
      params.permit(:id,
                    :customer_id,
                    :merchant_id,
                    :status,
                    :created_at,
                    :updated_at)
    end
end
