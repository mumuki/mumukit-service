require 'mumukit/auth'

helpers do
  def authorization_header
    env['HTTP_AUTHORIZATION']
  end

  def token
    @token ||= Mumukit::Auth::Token.decode_header(authorization_header).tap(&:verify_client!)
  end

  def permissions
    @permissions ||= token.permissions
  end

  def protect!(scope)
    permissions.protect! scope, slug.to_s
  end
end

error Mumukit::Auth::InvalidTokenError do
  halt 401
end

error Mumukit::Auth::UnauthorizedAccessError do
  halt 403
end
