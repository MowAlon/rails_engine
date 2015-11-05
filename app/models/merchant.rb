class Merchant < ActiveRecord::Base

  def self.most_revenue(merchant_count)
    top_x_merchants(sorted_data_by_merchant(successful_revenue_by_merchant), merchant_count)
  end

  def self.most_items_sold(merchant_count)
    top_x_merchants(sorted_data_by_merchant(successful_quantity_sold_by_merchant), merchant_count)
  end

  def self.revenue_by_date(date)
    {total_revenue: Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}, invoices: {created_at: date}).sum('invoice_items.unit_price * invoice_items.quantity')}
  end

  def self.single_merchant_revenue_by_date(id, date)
    if date
      {revenue: Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}, invoices: {created_at: date, merchant_id: id}).sum('invoice_items.unit_price * invoice_items.quantity')}
    else
      {revenue: Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}, invoices: {merchant_id: id}).sum('invoice_items.unit_price * invoice_items.quantity')}
    end
  end

  def self.favorite_customer(merchant_id)
    transaction_count_by_customer(merchant_id).sort_by{|customer, transaction_count| transaction_count}.reverse.first.first
  end

  private

    def self.sorted_data_by_merchant(successful_sales)
      successful_sales.sort_by{|merchant, revenue| revenue}.reverse
    end

    def self.top_x_merchants(merchant_data, merchant_count)
      merchant_data.first(merchant_count).map{|merchant, revenue| merchant}
    end

    def self.successful_revenue_by_merchant
      Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}).includes(:merchant).group(:merchant).sum('invoice_items.unit_price * invoice_items.quantity')
    end

    def self.successful_quantity_sold_by_merchant
      Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}).includes(:merchant).group(:merchant).sum('invoice_items.quantity')
    end

    def self.transaction_count_by_customer(merchant_id)
      Invoice.joins(:transactions).where(merchant_id: merchant_id, transactions: {result: "success"}).includes(:customer).group(:customer).count
    end
end
