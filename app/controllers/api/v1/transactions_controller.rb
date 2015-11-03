class Api::V1::TransactionsController < Api::V1::BaseController

  def object_type
    Transaction
  end

  private

    def finder_params
      params.permit(:id,
                    :invoice_id,
                    :credit_card_number,
                    :credit_card_expiration_date,
                    :result)
    end
end
