require "rails_helper"

RSpec.describe Api::V1::CustomersController, type: :controller do

  before do
    3.times {FactoryGirl.create(:customer)}
  end

  context "#index" do
    it "returns the right number of customers" do
      customer_count = Customer.count
      get :index, format: :json

      expect(json.count).to eq(customer_count)
    end

    it "returns an empty array if there are no customers" do
      Customer.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right customers" do
      customer = Customer.all.sample
      get :show, format: :json, id: customer.id

      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right customer by id" do
      customer = Customer.all.sample
      get :find, format: :json, id: customer.id

      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end

    it "finds the right customer by first name" do
      customer = Customer.all.sample
      get :find, format: :json, first_name: customer.first_name

      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end

    it "finds the right customer by last name" do
      customer = Customer.all.sample
      get :find, format: :json, last_name: customer.last_name

      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end

    it "returns null if customer isn't found" do
      get :find, format: :json, first_name: "Not a real first name"

      expect(response.body).to eq("null")
    end

    it "is case-insensitive" do
      customer = Customer.all.sample
      customer.update(first_name: "bob")
      search_name = "BoB"

      get :find, format: :json, first_name: search_name

      expect(json["first_name"]).to_not eq(search_name)
      expect(json["first_name"]).to eq(customer.first_name)
      expect(json["last_name"]).to eq(customer.last_name)
    end
  end

  context "#find_all" do
    before do
      Customer.first.update(first_name: "bob")
      Customer.second.update(first_name: "bob")
      Customer.third.update(first_name: "not_bob")
    end

    it "can find multiple customers from one attribute" do
      bob1 = Customer.first
      bob2 = Customer.second

      get :find_all, format: :json, first_name: "bob"

      expect(json.count).to eq(2)
      expect(json.first["first_name"]).to eq("bob")
      expect(json.first["last_name"]).to eq(bob1.last_name)
      expect(json.second["first_name"]).to eq("bob")
      expect(json.second["last_name"]).to eq(bob2.last_name)
    end

    it "returns an empty array if customers aren't found" do
      get :find_all, format: :json, first_name: "Not a real first name"

      expect(json).to eq([])
    end
  end

  context "#random" do
    it "returns a random customer" do
      get :random, format: :json

      first_name = json["first_name"]
      random = false
      5.times do
        get :random, format: :json
        if first_name != json["first_name"]
          random = true
          break
        end
      end

      expect(random).to be true
    end

    it "returns null if there are no customers" do
      Customer.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

  context "#invoices" do
    before do
      3.times {FactoryGirl.create(:invoice)}
    end

    it "returns the customer's invoices" do
      invoice = Invoice.first
      customer_id = invoice.customer_id
      Invoice.second.update(customer_id: customer_id)
      Invoice.third.update(customer_id: customer_id + 1)

      get :invoices, format: :json, id: customer_id

      expect(json.count).to eq(2)
      expect(json.first["customer_id"]).to eq(invoice.customer_id)
      expect(json.first["merchant_id"]).to eq(invoice.merchant_id)
      expect(json.first["status"]).to eq(invoice.status)
    end
  end

  context "#transactions" do
    before do
      3.times {FactoryGirl.create(:transaction)}
    end

    it "returns the customer's transactions" do
      customer_id = Invoice.first.customer_id
      Invoice.second.update(customer_id: customer_id)
      Invoice.third.update(customer_id: customer_id + 1)
      transaction = Transaction.first
      Transaction.first.invoice_id = Invoice.first.id
      Transaction.second.invoice_id = Invoice.second.id
      Transaction.third.invoice_id = Invoice.third.id

      get :transactions, format: :json, id: customer_id

      expect(json.count).to eq(2)
      expect(json.first["invoice_id"]).to eq(transaction.invoice_id)
      expect(json.first["credit_card_number"]).to eq(transaction.credit_card_number)
      expect(json.first["result"]).to eq(transaction.result)
    end
  end

  context "#favorite_merchant" do
    before do
      seed_orders(10)
    end

    it "returns a merchant" do
      customer_id = Customer.first.id
      Invoice.all.each{|invoice| invoice.update(customer_id: Customer.second.id)}
      invoice = Invoice.all.sample
      invoice.update(customer_id: customer_id)
      merchant = invoice.merchant

      get :favorite_merchant, format: :json, id: customer_id

      expect(json["name"]).to eq(merchant.name)
    end
  end

end
