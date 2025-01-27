class Api::V1::OrdersController < ApiController
  load_and_authorize_resource

  # GET /api/v1/orders
  def index
    @orders = current_user.orders.includes(:order_items)
    render json: @orders, include: :order_items, status: :ok
  end

  # POST /api/v1/orders
  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'pending'

    if @order.save
      render json: @order, include: :order_items, status: :created
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/orders/:id
  def show
    @order = current_user.orders.includes(:order_items).find_by(id: params[:id])
    if @order
      render json: @order, include: :order_items, status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  # PATCH /api/v1/orders/:id
  def update
    @order = current_user.orders.find_by(id: params[:id])
    if @order&.update(order_params)
      render json: @order, include: :order_items, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/orders/:id
  def destroy
    @order = current_user.orders.find_by(id: params[:id])
    if @order&.destroy
      render json: { message: 'Order successfully deleted' }, status: :no_content
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(:status, order_items_attributes: [:id, :product_id, :quantity, :_destroy])
  end
end
