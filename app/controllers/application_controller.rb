class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token

  def authenticate_user!
    # For development testing
    return if Rails.env.development? && Rails.configuration.x.disable_jwt

    enc_token, _options = token_and_options(request)
    user_uuid = AuthenticationService.validate(enc_token)

    # Just for demonstration; obviously not complete :)
    render json: nil, status: :unauthorized if user_uuid.blank?
  end
end
