require "rails_helper"

RSpec.describe Api::V1::MerchantsController, type: :controller do

  before do
    3.times {FactoryGirl.create(:merchant)}
  end

  context "#index" do
    it "returns the right number of merchants" do
      merchant_count = Merchant.count
      get :index, format: :json

      expect(json.count).to eq(merchant_count)
    end

    it "returns an empty array if there are no merchants" do
      Merchant.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right merchants" do
      merchant = Merchant.all.sample
      get :show, format: :json, id: merchant.id

      expect(json["name"]).to eq(merchant.name)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right merchant by id" do
      merchant = Merchant.all.sample
      get :find, format: :json, id: merchant.id

      expect(json["name"]).to eq(merchant.name)
    end

    it "finds the right merchant by name" do
      merchant = Merchant.all.sample
      get :find, format: :json, name: merchant.name

      expect(json["name"]).to eq(merchant.name)
    end

    it "returns null if merchant isn't found" do
      get :find, format: :json, name: "Not a real name"

      expect(response.body).to eq("null")
    end

    it "is case-insensitive" do
      merchant = Merchant.all.sample
      merchant.update(name: "bob's company")
      search_name = "BoB's COMpany"

      get :find, format: :json, name: search_name

      expect(json["name"]).to_not eq(search_name)
      expect(json["name"]).to eq(merchant.name)
    end
  end

  context "#find_all" do
    before do
      Merchant.first.update(name: "bob's company")
      Merchant.second.update(name: "bob's company")
      Merchant.third.update(name: "not bob's company")
    end

    it "can find multiple merchants from one attribute" do
      bob1 = Merchant.first
      bob2 = Merchant.second

      get :find_all, format: :json, name: "bob's company"

      expect(json.count).to eq(2)
      expect(json.first["name"]).to eq("bob's company")
      expect(json.second["name"]).to eq("bob's company")
    end

    it "returns an empty array if merchants aren't found" do
      get :find_all, format: :json, name: "Not a real name"

      expect(json).to eq([])
    end
  end

  context "#random" do
    it "returns a random merchant" do
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

    it "returns null if there are no merchants" do
      Merchant.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

  context "#items" do
    before do
      3.times {FactoryGirl.create(:item)}
    end

    it "returns items belonging to the requested merchant" do
      merchant_id = Item.first.merchant_id
      Item.first.update_attributes(name: "Test Item 1")
      Item.second.update_attributes(merchant_id: merchant_id,
                                    name: "Test Item 2")
      Item.third.update_attributes(merchant_id: merchant_id + 1,
                                    name: "Not Test Item")

      get :items, format: :json, id: merchant_id.to_s

      expect(json.count).to eq(2)
      expect(json.first["name"]).to eq("Test Item 1")
      expect(json.second["name"]).to eq("Test Item 2")
    end
  end

  context "#invoices" do
    before do
      3.times {FactoryGirl.create(:invoice)}
    end

    it "returns invoices belonging to the requested merchant" do
      merchant_id = Invoice.first.merchant_id
      Invoice.first.update_attributes(status: "Test Status 1")
      Invoice.second.update_attributes(merchant_id: merchant_id,
                                    status: "Test Status 2")
      Invoice.third.update_attributes(merchant_id: merchant_id + 1,
                                    status: "Not Test Status")

      get :invoices, format: :json, id: merchant_id.to_s

      expect(json.count).to eq(2)
      expect(json.first["status"]).to eq("Test Status 1")
      expect(json.second["status"]).to eq("Test Status 2")
    end
  end

  context "#most_revenue" do
    before do
      seed_orders(10)
    end

    it "returns X merchants" do
      merchant_count = 2

      get :most_revenue, format: :json, quantity: merchant_count

      expect(json.count).to eq(merchant_count)
      expect(json.first["name"]).to be_kind_of(String)
    end
  end

  context "#most_items" do
    before do
      seed_orders(10)
    end

    it "returns X merchants" do
      merchant_count = 3

      get :most_items, format: :json, quantity: merchant_count

      expect(json.count).to eq(merchant_count)
      expect(json.first["name"]).to be_kind_of(String)
    end
  end

  context "#revenue" do
    before do
      seed_orders(10)
    end

    it "returns 'total_revenue' for a supplied date" do
      date = Invoice.all.sample.created_at

      get :revenue, format: :json, date: date

      expect(json.keys.first).to eq("total_revenue")
      expect(json["total_revenue"]).to eq(json["total_revenue"].to_f.to_s)
    end
  end

  context "#single_merchant_revenue" do
    before do
      seed_orders(10)
    end

    it "returns 'revenue' for a specified merchant with a supplied date" do
      invoice = Invoice.all.sample
      merchant_id = invoice.merchant_id
      date = invoice.created_at

      get :single_merchant_revenue, format: :json, id: merchant_id, date: date

      expect(json.keys.first).to eq("revenue")
      expect(json["revenue"]).to eq(json["revenue"].to_f.to_s)
    end

    it "returns 'revenue' for a specified merchant without a supplied date" do
      merchant_id = Invoice.all.sample.merchant_id

      get :single_merchant_revenue, format: :json, id: merchant_id

      expect(json.keys.first).to eq("revenue")
      expect(json["revenue"]).to eq(json["revenue"].to_f.to_s)
    end
  end

  context "#favorite_customer" do
    before do
      seed_orders(10)
    end

    it "returns a customer" do
      merchant_id = Merchant.first.id
      Invoice.all.each{|invoice| invoice.update(merchant_id: Merchant.second.id)}
      invoice = Invoice.all.sample
      invoice.update(merchant_id: merchant_id)
      customer = invoice.customer

      get :favorite_customer, format: :json, id: merchant_id

      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end
  end

  context "#customers_with_pending_invoices" do
    before do
      seed_orders(10)
    end

    it "returns customers" do
      merchant_id = Merchant.first.id
      Invoice.all.each{|invoice| invoice.update(merchant_id: Merchant.second.id)}
      Invoice.all.sample(3).each{|invoice| invoice.update(merchant_id: merchant_id)}
      Transaction.all.each{|transaction| transaction.update(result: "failed")}

      get :customers_with_pending_invoices, format: :json, id: merchant_id

      expect(json.count).to eq(3)
      expect(json.first["first_name"]).to be_kind_of(String)
      expect(json.first["last_name"]).to be_kind_of(String)
    end
  end

end
