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

end
