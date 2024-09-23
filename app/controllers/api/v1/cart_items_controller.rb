class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:index, :create, :destroy]
  load_and_authorize_resource

  def index
    @cart_items = CartItem.where(cart_id: Cart.where(user_id: current_user.id).pluck(:id))
    render json: @cart_items
  end
 
  def create
    @cart_item = current_user.cart.cart_items.new(cart_item_params)
    authorize! :create, @cart_item
    if @cart_item.save
      render json: @cart_item, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @cart_item
    if @cart_item.update(cart_item_params)
      render json: {message: 'CartItem successfully updated',cart_item:@cart_item}, status: :ok
    else
      render json: { errors: @cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
      @cart_item.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
    render json: { message: 'Cart item deleted successfully' }, status: :ok
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end