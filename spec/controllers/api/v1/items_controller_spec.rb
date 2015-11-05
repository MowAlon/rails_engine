require "rails_helper"

RSpec.describe Api::V1::ItemsController, type: :controller do

  before do
    3.times {FactoryGirl.create(:item)}
  end

  context "#index" do
    it "returns the right number of items" do
      item_count = Item.count
      get :index, format: :json

      expect(json.count).to eq(item_count)
    end

    it "returns an empty array if there are no items" do
      Item.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right items" do
      item = Item.all.sample
      get :show, format: :json, id: item.id

      expect(json["name"]).to eq(item.name)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right item by id" do
      item = Item.all.sample
      get :find, format: :json, id: item.id

      expect(json["name"]).to eq(item.name)
    end

    it "finds the right item by name" do
      item = Item.all.sample
      get :find, format: :json, name: item.name

      expect(json["name"]).to eq(item.name)
    end

    it "finds the right item by description" do
      item = Item.all.sample
      get :find, format: :json, description: item.description

      expect(json["name"]).to eq(item.name)
    end

    it "finds the right item by unit_price" do
      item = Item.all.sample
      get :find, format: :json, unit_price: item.unit_price

      expect(json["name"]).to eq(item.name)
    end

    it "finds the right item by merchant_id" do
      item = Item.all.sample
      get :find, format: :json, merchant_id: item.merchant_id

      expect(json["name"]).to eq(item.name)
    end

    it "returns null if item isn't found" do
      get :find, format: :json, name: "Not a real name"

      expect(response.body).to eq("null")
    end

    it "is case-insensitive" do
      item = Item.all.sample
      item.update(name: "bob's widget")
      search_name = "BoB's WIDget"

      get :find, format: :json, name: search_name

      expect(json["name"]).to_not eq(search_name)
      expect(json["name"]).to eq(item.name)
    end
  end

  context "#find_all" do
    before do
      Item.first.update(name: "bob's widget")
      Item.second.update(name: "bob's widget")
      Item.third.update(name: "not bob's widget")
    end

    it "can find multiple items from one attribute" do
      bob1 = Item.first
      bob2 = Item.second

      get :find_all, format: :json, name: "bob's widget"

      expect(json.count).to eq(2)
      expect(json.first["name"]).to eq("bob's widget")
      expect(json.second["name"]).to eq("bob's widget")
    end

    it "returns an empty array if items aren't found" do
      get :find_all, format: :json, name: "Not a real name"

      expect(json).to eq([])
    end
  end

  context "#random" do
    it "returns a random item" do
      get :random, format: :json

      name = json["name"]
      random = false
      5.times do
        get :random, format: :json
        if name != json["name"]
          random = true
          break
        end
      end

      expect(random).to be true
    end

    it "returns null if there are no items" do
      Item.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

  context "#merchant" do
    it "returns the item's merchant" do
      item = Item.all.sample
      merchant = item.merchant

      get :merchant, format: :json, id: item.id

      expect(json["name"]).to eq(merchant.name)
    end
  end

  context "#invoice_items" do
    before do
      3.times {FactoryGirl.create(:invoice_item)}
    end

    it "returns the item's invoice items" do
      item = Item.first
      InvoiceItem.all.each{|invoice_item| invoice_item.update(item_id: Item.second.id)}
      invoice_item = InvoiceItem.first
      invoice_item.update(item_id: item.id)
      InvoiceItem.second.update(item_id: item.id)

      get :invoice_items, format: :json, id: item.id

      expect(json.count).to eq(2)
      expect(json.first["id"]).to eq(invoice_item.id)
      expect(json.first["item_id"]).to eq(invoice_item.item_id)
      expect(json.first["invoice_id"]).to eq(invoice_item.invoice_id)
      expect(json.first["unit_price"]).to eq(invoice_item.unit_price.to_s)
      expect(json.first["quantity"]).to eq(invoice_item.quantity)
    end
  end

end
