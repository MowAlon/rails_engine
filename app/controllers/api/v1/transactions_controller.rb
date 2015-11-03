class Api::V1::TransactionsController < Api::V1::BaseController

  def object_type
    Transaction
  end

  def invoice
    current_transaction.invoice
  end

  private

    def current_transaction
      Transaction.find_by(id: params[:id])
    end

    def finder_params
      params.permit(:id,
                    :invoice_id,
                    :credit_card_number,
                    :credit_card_expiration_date,
                    :result)
    end
end
