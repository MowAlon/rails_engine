class Api::V1::ItemsController < Api::V1::BaseController

  def object_type
    Item
  end

  private

    def finder_params
      params.permit(:id,
                    :name,
                    :description,
                    :unit_price,
                    :merchant_id)
    end
end
