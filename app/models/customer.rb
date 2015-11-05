class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :transactions, through: :invoices

  def self.favorite_merchant(customer_id)
    transaction_count_by_merchant(customer_id).sort_by{|merchant, transaction_count| transaction_count}.reverse.first.first
  end

  private
  
    def self.transaction_count_by_merchant(customer_id)
      Invoice.joins(:transactions).where(customer_id: customer_id, transactions: {result: "success"}).includes(:merchant).group(:merchant).count
    end
end
