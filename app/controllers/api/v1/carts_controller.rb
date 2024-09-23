class Api::V1::CartsController < ApiController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart
    render json: {
      cart_items: @cart.cart_items.includes(:product).to_json(include: :product)
    }
  end
end
