require 'sinatra'
require 'sinatra/cross_origin'
require 'logger'
require 'mumukit/auth'

require 'json'
require 'yaml'

access_logger = Logger.new(File.join 'logs', 'sinatra.log')
error_logfile = File.new(File.join('logs', 'error.log'), 'a+')

configure do
  enable :cross_origin
  set :allow_methods, [:get, :put, :post, :options, :delete]
  set :show_exceptions, false

  use ::Rack::CommonLogger, access_logger

  Mongo::Logger.logger = ::Logger.new(File.join 'logs', 'mongo.log')
  Mongo::Logger.logger.level = ::Logger::INFO
end

helpers do
  def json_body
    @json_body ||= JSON.parse(request.body.read) rescue nil
  end

  def slug
    if route_slug_parts.present?
      Mumukit::Auth::Slug.join(*route_slug_parts)
    elsif subject
      Mumukit::Auth::Slug.parse(subject.slug)
    elsif json_body
      Mumukit::Auth::Slug.parse(json_body['slug'])
    else
      raise Mumukit::Auth::InvalidSlugFormatError.new('Slug not available')
    end
  end

  def route_slug_parts
    []
  end
end

before do
  content_type 'application/json', 'charset' => 'utf-8'
  env["rack.errors"] = error_logfile
end

after do
  error_message = env['sinatra.error']
  if response.body.is_a?(Array)&& response.body[0].is_a?(String)
    content_type 'text/html'
    response.body = <<HTML
    <html>
      <body>
        #{response.body[0]}
      </body>
    </html>
HTML
  elsif error_message.blank?
    response.body = response.body.to_json
  else
    response.body = {message: env['sinatra.error'].message}.to_json
  end
end

error JSON::ParserError do
  halt 400
end

error Mumukit::Service::DocumentValidationError do
  halt 400
end

error Mumukit::Service::DocumentNotFoundError do
  halt 404
end

error Mumukit::Auth::InvalidTokenError do
  halt 401
end

error Mumukit::Auth::UnauthorizedAccessError do
  halt 403
end

error Mumukit::Auth::InvalidSlugFormatError do
  halt 400
end

options '*' do
  response.headers['Allow'] = settings.allow_methods.map { |it| it.to_s.upcase }.join(',')
  response.headers['Access-Control-Allow-Headers'] = 'X-Mumuki-Auth-Token, X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization'
  200
end



