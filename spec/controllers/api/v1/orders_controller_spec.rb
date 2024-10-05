require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }

  before do
    sign_in user # For Devise authentication
  end

  # Helper method to parse JSON response
  def json_response
    JSON.parse(response.body)
  end

  describe "GET #index" do
    it "returns a list of orders for the current user" do
      get :index
      expect(response).to have_http_status(:success)
      expect(json_response.length).to eq(user.orders.count)
    end
  end

  describe "POST #create" do
    it "creates a new order" do
      expect {
        post :create, params: { order: { product_id: 1, quantity: 2 } }
      }.to change(Order, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns an error when order is invalid" do
      post :create, params: { order: { order_items_attributes: [{ product_id: nil, quantity: nil }] } }
      expect(response).to have_http_status(:unprocessable_entity)

      # Adjust the expected error messages to match the actual ones
      expect(json_response['errors']).to include(
        "Order items product must exist",
        "Order items quantity can't be blank"
      )
    end
  end

  describe "GET #show" do
    it "returns the order" do
      get :show, params: { id: order.id }
      expect(response).to have_http_status(:success)
      expect(json_response['id']).to eq(order.id)
    end
  end

  describe "PATCH #update" do
    it "updates an existing order" do
      patch :update, params: { id: order.id, order: { status: 'completed' } }
      expect(response).to have_http_status(:success)
      order.reload
      expect(order.status).to eq('completed')
    end

    it "returns an error when order is invalid" do
      patch :update, params: { id: order.id, order: { status: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the order" do
      order # Ensure order is created
      expect {
        delete :destroy, params: { id: order.id }
      }.to change(Order, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
