# frozen_string_literal: true

module AuthenticationService
  extend self

  HMAC_SECRET = Rails.configuration.x.hmac_secret
  HMAC_ALGO   = Rails.configuration.x.hmac_algo

  def login(username:, password:)
    # Replace the sample with a real lookup against a table of credentials.
    payload = { user_uuid: username }

    JWT.encode(payload, HMAC_SECRET, HMAC_ALGO)
  end

  def validate(enc_token)
    begin
      dec_token = JWT.decode(enc_token, HMAC_SECRET, true, { algorithm: HMAC_ALGO })

      dec_token&.first&.[]('user_uuid')
    rescue JWT::DecodeError
      nil
    end
  end
end
