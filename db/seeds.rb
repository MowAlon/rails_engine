require 'csv'

class Seed

  def initialize
    create_customers
    create_merchants
    create_invoices
    create_items
    create_transactions
    create_invoice_items
  end

  def data_folder
    File.join(File.expand_path('../..',  __FILE__), "data")
  end

  def create_customers
    CSV.foreach(File.join(data_folder, 'customers.csv'), headers: true, :header_converters => :symbol) do |row|
      Customer.create(row.to_hash)
    end
  end

  def create_merchants
    CSV.foreach(File.join(data_folder, 'merchants.csv'), headers: true, :header_converters => :symbol) do |row|
      Merchant.create(row.to_hash)
    end
  end

  def create_invoices
    CSV.foreach(File.join(data_folder, 'invoices.csv'), headers: true, :header_converters => :symbol) do |row|
      Invoice.create(row.to_hash)
    end
  end

  def create_items
    CSV.foreach(File.join(data_folder, 'items.csv'), headers: true, :header_converters => :symbol) do |row|
      Item.create(row.to_hash)
    end
  end

  def create_transactions
    CSV.foreach(File.join(data_folder, 'transactions.csv'), headers: true, :header_converters => :symbol) do |row|
      Transaction.create(row.to_hash)
    end
  end

  def create_invoice_items
    CSV.foreach(File.join(data_folder, 'invoice_items.csv'), headers: true, :header_converters => :symbol) do |row|
      InvoiceItem.create(row.to_hash)
    end
  end
end

seed = Seed.new
