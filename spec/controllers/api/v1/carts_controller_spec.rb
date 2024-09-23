require 'rails_helper'

RSpec.describe Api::V1::CartsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:cart_item) { create(:cart_item, cart: cart) } # Ensure there's at least one cart item

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #show' do
    context 'when the user is authenticated' do
      before do
        sign_in user
        get :show, params: { id: cart.id }, format: :json
      end

      it 'returns the user cart with cart items' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        puts "Response: #{json_response.inspect}" # Debugging output
        
        expect(json_response).to include('cart_items')
        expect(json_response['cart_items']).not_to be_empty # Check that cart_items is not empty
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        get :show, params: { id: cart.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
