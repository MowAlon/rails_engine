require 'rails_helper'

RSpec.describe Api::V1::Customer, type: :model do
  before do
    seed_orders(10)
  end

  it "#favorite_merchant returns a merchant" do
    customer_id = Customer.all.sample.id
    Invoice.all.sample.update_attributes(customer_id: customer_id)
    response = Customer.favorite_merchant(customer_id)

    expect(response).to be_kind_of(Merchant)
  end
end
