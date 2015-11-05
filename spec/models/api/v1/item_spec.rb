require 'rails_helper'

RSpec.describe Api::V1::Item, type: :model do
  before do
    seed_orders(10)
  end

  it "#most_revenue returns X items" do
    item_count = 4
    items = Item.most_revenue(item_count)

    expect(items.count).to eq(item_count)
    expect(items.first).to be_kind_of(Item)
  end

  it "#most_items_sold returns X items" do
    item_count = 3
    items = Item.most_items_sold(item_count)

    expect(items.count).to eq(item_count)
    expect(items.first).to be_kind_of(Item)
  end

  it "#best_day returns a hash with 'best_day' for a specified item and with a supplied date" do
    item_id = Item.all.sample.id

    response = Item.best_day(item_id)

    expect(response).to be_kind_of(Hash)
    expect(response.keys.first).to eq(:best_day)
    expect(response[:best_day]).to be_kind_of(Time)
  end
end
