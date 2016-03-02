require 'sinatra'
require 'sinatra/cross_origin'

require 'json'
require 'yaml'

configure do
  enable :cross_origin
  set :allow_methods, [:get, :put, :post, :options, :delete]
  set :show_exceptions, false

  Mongo::Logger.logger = ::Logger.new('mongo.log')
end

helpers do
  def json_body
    @json_body ||= JSON.parse(request.body.read) rescue nil
  end

  def slug
    if params[:organization] && params[:repository]
      Mumukit::Service::Slug.new(params[:organization], params[:repository])
    elsif subject
      Mumukit::Service::Slug.from(subject.slug)
    elsif json_body
      Mumukit::Service::Slug.from(json_body['slug'])
    else
      raise Mumukit::Service::InvalidSlugFormatError.new('Slug not available')
    end
  end
end

before do
  content_type 'application/json', 'charset' => 'utf-8'
end

after do
  error_message = env['sinatra.error']
  if error_message.blank?
    response.body = response.body.to_json
  else
    response.body = {message: env['sinatra.error'].message}.to_json
  end
end

error JSON::ParserError do
  halt 400
end

error Mumukit::Service::InvalidSlugFormatError do
  halt 400
end

error Mumukit::Service::DocumentValidationError do
  halt 400
end

error Mumukit::Service::DocumentNotFoundError do
  halt 404
end

options '*' do
  response.headers['Allow'] = settings.allow_methods.map { |it| it.to_s.upcase }.join(',')
  response.headers['Access-Control-Allow-Headers'] = 'X-Mumuki-Auth-Token, X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization'
  200
end



