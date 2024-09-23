class Api::V1::ProductsController < ApiController
  before_action :set_product, only: [:update, :destroy]
  before_action :authenticate_user!

  def index
    if current_user.admin? || current_user.user?
      @products = Product.all
    else
      @products = current_user.products
    end
    render json: @products, status: :ok
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = if current_user.admin?
                 Product.find(params[:id])
               else
                 current_user.products.find_by(id: params[:id])
               end
    raise ActiveRecord::RecordNotFound unless @product
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end