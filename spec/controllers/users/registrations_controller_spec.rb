require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'when the user is successfully created' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'returns a success response with user data' do
        post :create, params: valid_params, format: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message'])
          .to eq('Signed up Successfully')
        expect(json_response['status']['data']['email'])
          .to eq('test@example.com')
      end
    end

    context 'when the user creation fails' do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid-email',
            password: 'password',
            password_confirmation: 'mismatch'
          }
        }
      end

      it 'returns an error response' do
        post :create, params: invalid_params, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message'])
          .to eq('User not be created Successfully')
        expect(json_response['status']['errors'])
          .to include("Email is invalid")
        expect(json_response['status']['errors'])
          .to include("Password confirmation doesn't match Password")
      end
    end
  end
end
