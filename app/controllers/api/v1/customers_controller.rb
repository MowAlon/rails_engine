class Api::V1::CustomersController < Api::V1::BaseController

  def object_type
    Customer
  end

  private

    def finder_params
      params.permit(:id,
                    :first_name,
                    :last_name)
    end
end
