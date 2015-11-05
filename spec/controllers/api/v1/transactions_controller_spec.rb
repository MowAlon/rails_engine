require "rails_helper"

RSpec.describe Api::V1::TransactionsController, type: :controller do

  before do
    3.times {FactoryGirl.create(:transaction)}
  end

  context "#index" do
    it "returns the right number of transactions" do
      transaction_count = Transaction.count
      get :index, format: :json

      expect(json.count).to eq(transaction_count)
    end

    it "returns an empty array if there are no transactions" do
      Transaction.delete_all
      get :index, format: :json

      expect(json).to eq([])
    end
  end

  context "#show" do
    it "returns the right transactions" do
      transaction = Transaction.all.sample
      get :show, format: :json, id: transaction.id

      expect(json["id"]).to eq(transaction.id)
    end

    it "returns null for an unknown id" do
      get :show, format: :json, id: -1

      expect(response.body).to eq("null")
    end
  end

  context "#find" do
    it "finds the right transaction by id" do
      transaction = Transaction.all.sample
      get :find, format: :json, id: transaction.id

      expect(json["id"]).to eq(transaction.id)
    end

    it "finds the right transaction by invoice_id" do
      transaction = Transaction.all.sample
      get :find, format: :json, invoice_id: transaction.invoice_id

      expect(json["id"]).to eq(transaction.id)
    end

    it "finds the right transaction by credit_card_number" do
      transaction = Transaction.all.sample
      transaction.update(credit_card_number: "1234*5678*9012*3456")
      get :find, format: :json, credit_card_number: transaction.credit_card_number

      expect(json["id"]).to eq(transaction.id)
    end

    it "finds the right transaction by result" do
      transaction = Transaction.all.sample
      transaction.update(result: "transaction_result")
      get :find, format: :json, result: transaction.result

      expect(json["id"]).to eq(transaction.id)
    end

    it "returns null if transaction isn't found" do
      get :find, format: :json, invoice_id: -1

      expect(response.body).to eq("null")
    end

    it "is case-insensitive" do
      transaction = Transaction.all.sample
      transaction.update(result: "transaction_result")
      search_result = "TrAnSaCtIoN_rEsUlT"

      get :find, format: :json, result: search_result

      expect(json["result"]).to_not eq(search_result)
      expect(json["result"]).to eq(transaction.result)
    end
  end

  context "#find_all" do
    before do
      Transaction.first.update(result: "success")
      Transaction.second.update(result: "success")
      Transaction.third.update(result: "failed")
    end

    it "can find multiple transactions from one attribute" do
      success1 = Transaction.first
      success2 = Transaction.second

      get :find_all, format: :json, result: "success"

      expect(json.count).to eq(2)
      expect(json.first["result"]).to eq("success")
      expect(json.second["result"]).to eq("success")
    end

    it "returns an empty array if transactions aren't found" do
      get :find_all, format: :json, result: "Not a real result"

      expect(json).to eq([])
    end
  end

  context "#random" do
    before do
      Transaction.first.update(result: "success1")
      Transaction.second.update(result: "success2")
      Transaction.third.update(result: "success3")
    end

    it "returns a random transaction" do
      get :random, format: :json

      result = json["result"]
      random = false
      5.times do
        get :random, format: :json
        if result != json["result"]
          random = true
          break
        end
      end

      expect(random).to be true
    end

    it "returns null if there are no transactions" do
      Transaction.delete_all
      get :random, format: :json

      expect(response.body).to eq("null")
    end
  end

  context "#invoice" do
    it "returns the transaction's invoice" do
      transaction = Transaction.first
      invoice = transaction.invoice

      get :invoice, format: :json, id: transaction.id

      expect(json["id"]).to eq(transaction.invoice_id)
      expect(json["customer_id"]).to eq(invoice.customer_id)
      expect(json["merchant_id"]).to eq(invoice.merchant_id)
      expect(json["status"]).to eq(invoice.status)
    end
  end

end
