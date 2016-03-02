require 'mumukit/auth'

helpers do
  def authorization_header
    env['HTTP_AUTHORIZATION']
  end

  def token
    @token ||= Mumukit::Auth::Token.decode_header(authorization_header).tap(&:verify_client!)
  end

  def permissions
    @permissions ||= token.permissions settings.app_name
  end

  def protect!
    permissions.protect! slug.to_s
  end
end

error Mumukit::Auth::InvalidTokenError do
  halt 400
end

error Mumukit::Auth::UnauthorizedAccessError do
  halt 403
end