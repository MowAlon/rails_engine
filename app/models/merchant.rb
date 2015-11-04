class Merchant < ActiveRecord::Base

  def self.most_revenue(merchant_count)
    sorted_revenue_by_merchant.first(merchant_count).map{|merchant, revenue| merchant}
  end

  private

    def self.sorted_revenue_by_merchant
      successful_revenue_by_merchant.sort_by{|merchant, revenue| revenue}.reverse
    end

    def self.successful_revenue_by_merchant
      Invoice.joins(:invoice_items, :transactions).where(transactions: {result: "success"}).includes(:merchant).group(:merchant).sum('invoice_items.unit_price * invoice_items.quantity')
    end
end
