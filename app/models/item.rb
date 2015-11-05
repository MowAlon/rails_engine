class Item < ActiveRecord::Base
  belongs_to :merchant

  def self.most_revenue(quantity)
    top_revenue_by_item_ids(quantity).map{|item_id, revenue| Item.find(item_id)}
  end

  def self.most_items_sold(quantity)
    top_quantity_sold_by_item_ids(quantity).map{|item_id, quantity| Item.find(item_id)}
  end

  def self.best_day(item_id)
    {:best_day => Invoice.joins(:transactions, :invoice_items).where(transactions: {result: "success"}, invoice_items: {item_id: item_id}).group('invoices.created_at').sum(:quantity)
      .sort_by{|date, quantity| quantity}.reverse.first.first}
  end

  private

    def self.top_revenue_by_item_ids(quantity)
      revenue_by_item_ids.sort_by{|item_id, revenue| revenue}.reverse.first(quantity)
    end

    def self.revenue_by_item_ids
      Invoice.joins(:transactions, :invoice_items).where(transactions: {result: "success"}).group(:item_id).sum('unit_price * quantity')
    end

    def self.top_quantity_sold_by_item_ids(quantity)
      quantity_sold_by_item_ids.sort_by{|item_id, quantity| quantity}.reverse.first(quantity)
    end

    def self.quantity_sold_by_item_ids
      Invoice.joins(:transactions, :invoice_items).where(transactions: {result: "success"}).group(:item_id).sum('quantity')
    end
end
