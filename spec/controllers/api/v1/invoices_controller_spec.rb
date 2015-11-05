require "rails_helper"

RSpec.describe Api::V1::InvoicesController, type: :controller do

  before do
    3.times {FactoryGirl.create(:invoice)}
  end

  context "#index" do
    it "returns the right number of invoices" do
      invoice_count = Invoice.count
      get :index, format: :json

      expect(json.count).to eq(invoice_count)
    end

    it "returns an empty array if there are no invoices" do
      Invoice.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right invoices" do
      invoice = Invoice.all.sample
      get :show, format: :json, id: invoice.id

      expect(json["id"]).to eq(invoice.id)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right invoice by id" do
      invoice = Invoice.all.sample
      get :find, format: :json, id: invoice.id

      expect(json["id"]).to eq(invoice.id)
    end

    it "finds the right invoice by customer_id" do
      invoice = Invoice.all.sample
      get :find, format: :json, customer_id: invoice.customer_id

      expect(json["id"]).to eq(invoice.id)
    end

    it "finds the right invoice by merchant_id" do
      invoice = Invoice.all.sample
      get :find, format: :json, merchant_id: invoice.merchant_id

      expect(json["id"]).to eq(invoice.id)
    end

    it "finds the right invoice by status" do
      invoice = Invoice.all.sample
      invoice.update(status: "test_status")
      get :find, format: :json, status: invoice.status

      expect(json["id"]).to eq(invoice.id)
    end

    it "returns null if invoice isn't found" do
      get :find, format: :json, customer_id: -1

      expect(response.body).to eq("null")
    end

    it "is case-insensitive" do
      invoice = Invoice.all.sample
      invoice.update(status: "test_status")
      search_status = "TeSt_sTaTuS"

      get :find, format: :json, status: search_status

      expect(json["status"]).to_not eq(search_status)
      expect(json["status"]).to eq(invoice.status)
    end
  end

  context "#find_all" do
    before do
      Invoice.first.update(status: "test status")
      Invoice.second.update(status: "test status")
      Invoice.third.update(status: "not a test status")
    end

    it "can find multiple invoices from one attribute" do
      invoice1 = Invoice.first
      invoice2 = Invoice.second

      get :find_all, format: :json, status: "test status"

      expect(json.count).to eq(2)
      expect(json.first["status"]).to eq("test status")
      expect(json.second["status"]).to eq("test status")
    end

    it "returns an empty array if invoices aren't found" do
      get :find_all, format: :json, status: "Not a real status"

      expect(json).to eq([])
    end
  end

  context "#random" do
    before do
      Invoice.first.update(status: "status1")
      Invoice.second.update(status: "status2")
      Invoice.third.update(status: "status3")
    end

    it "returns a random invoice" do
      get :random, format: :json

      status = json["status"]
      random = false
      5.times do
        get :random, format: :json
        if status != json["status"]
          random = true
          break
        end
      end

      expect(random).to be true
    end

    it "returns null if there are no invoices" do
      Invoice.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

  context "#merchant" do
    it "returns the invoice's merchant" do
      invoice = Invoice.all.sample
      merchant = invoice.merchant

      get :merchant, format: :json, id: invoice.id

      expect(json["name"]).to eq(merchant.name)
    end
  end

  context "#invoice_items" do
    before do
      3.times {FactoryGirl.create(:invoice_item)}
    end

    it "returns the invoice's invoice items" do
      invoice = Invoice.first
      InvoiceItem.all.each{|invoice_item| invoice_item.update(invoice_id: Invoice.second.id)}
      invoice_item = InvoiceItem.first
      invoice_item.update(invoice_id: invoice.id)
      InvoiceItem.second.update(invoice_id: invoice.id)

      get :invoice_items, format: :json, id: invoice.id

      expect(json.count).to eq(2)
      expect(json.first["id"]).to eq(invoice_item.id)
      expect(json.first["item_id"]).to eq(invoice_item.item_id)
      expect(json.first["invoice_id"]).to eq(invoice_item.invoice_id)
      expect(json.first["unit_price"]).to eq(invoice_item.unit_price.to_s)
      expect(json.first["quantity"]).to eq(invoice_item.quantity)
    end
  end

end
