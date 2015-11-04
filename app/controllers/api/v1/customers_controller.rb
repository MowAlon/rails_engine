class Api::V1::CustomersController < Api::V1::BaseController

  def object_type
    Customer
  end

  def invoices
    respond_with Invoice.where(customer_id: params[:id])
  end

  def transactions
    respond_with current_customer.transactions
  end

  private

    def current_customer
      Customer.find(params[:id])
    end

    def finder_params
      params.permit(:id,
                    :first_name,
                    :last_name,
                    :created_at,
                    :updated_at)
    end
end
