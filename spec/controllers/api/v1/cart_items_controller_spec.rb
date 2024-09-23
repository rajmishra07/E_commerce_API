require 'rails_helper'

RSpec.describe Api::V1::CartItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, format: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { { cart_item: { cart_id: cart.id, product_id: product.id, quantity: 1 } } }

      it "creates a new CartItem" do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(CartItem, :count).by(1)

        expect(response).to have_http_status(:created) # Check for 201 status
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { cart_item: { cart_id: nil, product_id: nil } } }

      it "does not create a new CartItem" do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.to change(CartItem, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested cart_item" do
      expect {
        delete :destroy, params: { id: cart_item.id }, format: :json
      }.to change(CartItem, :count).by(-1)

      expect(response).to have_http_status(:no_content) 
    end

    it "returns not found if the cart item does not exist" do
      expect {
        delete :destroy, params: { id: 0 }, format: :json
      }.to raise_error(ActiveRecord::RecordNotFound)

    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) { { cart_item: { quantity: 2 } } }

      it "updates the requested cart_item" do
        put :update, params: { id: cart_item.id }.merge(new_attributes), format: :json
        cart_item.reload
        expect(cart_item.quantity).to eq(2) 
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { cart_item: { quantity: nil } } }

      it "does not update the cart_item and returns errors" do
        put :update, params: { id: cart_item.id }.merge(invalid_attributes), format: :json
        cart_item.reload
        expect(cart_item.quantity).not_to be_nil 
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end