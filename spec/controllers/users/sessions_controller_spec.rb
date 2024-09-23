require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    request.headers['Accept'] = 'application/json'
  end

  describe 'DELETE #destroy' do
    context 'when signing out a user' do
      it 'signs out the user successfully' do
        # Simulate user sign in
        sign_in(user)

        # Mock the Authorization header with JWT token
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        request.headers['Authorization'] = "Bearer #{token}"

        delete :destroy

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Signed out successfully')
      end

      it 'returns unauthorized if the user has no active session' do
        delete :destroy

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('User has no active session')
      end
    end
  end
end