class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  respond_to :html, :json

  def favicon
    send_file Rails.root.join('app', 'assets', 'images', 'favicon.ico')
  end

   def authenticate_user!(options = {})
    if user_signed_in?
      super(options)
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end