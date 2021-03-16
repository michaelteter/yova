class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token

  def authenticate_user!
    # For easier dev testing, uncomment this auth bypass below.
    # return true

    enc_token, _options = token_and_options(request)
    user_uuid = AuthenticationService.validate(enc_token)

    # Just for demonstration; obviously not complete :)
    render json: nil, status: :unauthorized if user_uuid.blank?
  end
end
