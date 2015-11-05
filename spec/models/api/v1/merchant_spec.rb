require 'rails_helper'

RSpec.describe Api::V1::Merchant, type: :model do
  before do
    seed_orders(10)
  end

  it "#most_revenue returns X merchants" do
    merchant_count = 4
    merchants = Merchant.most_revenue(merchant_count)

    expect(merchants.count).to eq(merchant_count)
    expect(merchants.first).to be_kind_of(Merchant)
  end

  it "#most_items_sold returns X merchants" do
    merchant_count = 3
    merchants = Merchant.most_items_sold(merchant_count)

    expect(merchants.count).to eq(merchant_count)
    expect(merchants.first).to be_kind_of(Merchant)
  end

  it "#revenue_by_date returns a hash with 'total_revenue' for a supplied date" do
    date = Invoice.all.sample.created_at

    response = Merchant.revenue_by_date(date)

    expect(response).to be_kind_of(Hash)
    expect(response.keys.first).to eq(:total_revenue)
    expect(response[:total_revenue]).to be_kind_of(BigDecimal)
  end

  it "#single_merchant_revenue returns a hash with 'revenue' for a specified merchant and with a supplied date" do
    invoice = Invoice.all.sample
    merchant_id = invoice.merchant_id
    date = invoice.created_at

    response = Merchant.single_merchant_revenue(merchant_id, date)

    expect(response).to be_kind_of(Hash)
    expect(response.keys.first).to eq(:revenue)
    expect(response[:revenue]).to be_kind_of(BigDecimal)
  end

  it "#single_merchant_revenue returns a hash with 'revenue' for a specified merchant and without a supplied date" do
    invoice = Invoice.all.sample
    merchant_id = invoice.merchant_id

    response = Merchant.single_merchant_revenue(merchant_id)

    expect(response).to be_kind_of(Hash)
    expect(response.keys.first).to eq(:revenue)
    expect(response[:revenue]).to be_kind_of(BigDecimal)
  end

  it "#favorite_customer returns a customer" do
    merchant_id = Merchant.all.sample.id
    Invoice.all.sample.update_attributes(merchant_id: merchant_id)
    response = Merchant.favorite_customer(merchant_id)

    expect(response).to be_kind_of(Customer)
  end

  it "#customers_with_pending_invoices returns an array of customers" do
    merchant_id = Merchant.all.sample.id
    Invoice.all.each{|invoice| invoice.update(merchant_id: merchant_id + 1)}
    Invoice.all.sample(3).each{|invoice| invoice.update(merchant_id: merchant_id)}
    Transaction.all.each{|transaction| transaction.update(result: "failed")}

    response = Merchant.customers_with_pending_invoices(merchant_id)

    expect(response.count).to eq(3)
    expect(response).to be_kind_of(Array)
    expect(response.first).to be_kind_of(Customer)
  end
end
