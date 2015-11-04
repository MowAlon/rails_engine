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

  def wip
    # GET /api/v1/merchants/most_revenue?quantity=x returns the top x merchants ranked by total revenue

    # Cool debug output for totaling revenue for a collection of invoices
    total = invoices.reduce(0){|sum, invoice|puts "$#{invoice.unit_price} * #{invoice.quantity} = $#{invoice.unit_price * invoice.quantity}";sum += (invoice.unit_price * invoice.quantity)};puts "----------------------\n$#{total}"

    # Produces an array of the subtotals for an invoices invoice_items
    invoice.invoice_items.pluck('unit_price * quantity')
    # Single query to sum the subtotals of an invoice
    invoice.invoice_items.sum('unit_price * quantity')

    # Produces a hash of all invoice_ids and corresponding revenue totals
    InvoiceItem.all.group(:invoice_id).sum("unit_price * quantity")

    # Produces a hash of all successful invoice_ids and corresponding revenue totals
    successful_invoices = Invoice.joins(:transactions).where(transactions: {result: "success"}).pluck(:id)
    InvoiceItem.where(invoice_id: successful_invoices).group(:invoice_id).sum('unit_price * quantity')

  end

  private

    def finder_params
      params.permit(:id,
                    :name,
                    :created_at,
                    :updated_at)
    end
end
