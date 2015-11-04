require "rails_helper"

RSpec.describe Api::V1::InvoiceItemsController, type: :controller do

  before do
    3.times {FactoryGirl.create(:invoice_item)}
  end

  context "#index" do
    it "returns the right number of invoice_items" do
      invoice_item_count = InvoiceItem.count
      get :index, format: :json

      expect(json.count).to eq(invoice_item_count)
    end

    it "returns an empty array if there are no invoice_items" do
      InvoiceItem.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right invoice_items" do
      invoice_item = InvoiceItem.all.sample
      get :show, format: :json, id: invoice_item.id

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right invoice_item by id" do
      invoice_item = InvoiceItem.all.sample
      get :find, format: :json, id: invoice_item.id

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "finds the right invoice_item by item_id" do
      invoice_item = InvoiceItem.all.sample
      get :find, format: :json, item_id: invoice_item.item_id

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "finds the right invoice_item by invoice_id" do
      invoice_item = InvoiceItem.all.sample
      get :find, format: :json, invoice_id: invoice_item.invoice_id

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "finds the right invoice_item by quantity" do
      invoice_item = InvoiceItem.all.sample
      invoice_item.update(quantity: 66)
      get :find, format: :json, quantity: invoice_item.quantity

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "finds the right invoice_item by unit_price" do
      invoice_item = InvoiceItem.all.sample
      invoice_item.update(unit_price: 66666)
      get :find, format: :json, unit_price: invoice_item.unit_price

      expect(json["id"]).to eq(invoice_item.id)
    end

    it "returns null if invoice_item isn't found" do
      get :find, format: :json, item_id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find_all" do
    before do
      InvoiceItem.first.update(unit_price: 11111)
      InvoiceItem.second.update(unit_price: 11111)
      InvoiceItem.third.update(unit_price: 33333)
    end

    it "can find multiple invoice_items from one attribute" do
      invoice_item1 = InvoiceItem.first
      invoice_item2 = InvoiceItem.second

      get :find_all, format: :json, unit_price: 11111

      expect(json.count).to eq(2)
      expect(json.first["unit_price"]).to eq(11111)
      expect(json.second["unit_price"]).to eq(11111)
    end

    it "returns an empty array if invoice_items aren't found" do
      get :find_all, format: :json, unit_price: -1

      expect(json).to eq([])
    end
  end

  context "#random" do
    before do
      InvoiceItem.first.update(unit_price: 11111)
      InvoiceItem.second.update(unit_price: 22222)
      InvoiceItem.third.update(unit_price: 33333)
    end

    it "returns a random invoice_item" do
      get :random, format: :json

      unit_price = json["unit_price"]
      random = false
      5.times do
        get :random, format: :json
        if unit_price != json["unit_price"]
          random = true
          break
        end
      end

      expect(random).to be true
    end

    it "returns null if there are no invoice_items" do
      InvoiceItem.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

end
