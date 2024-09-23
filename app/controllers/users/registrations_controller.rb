class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up Successfully', data: resource }
      }, status: :ok
    else
      render json: {
        status: { message: 'User not be created Successfully', errors: resource.errors.full_messages }
      }, status: :unprocessable_entity  
    end
  end
end
