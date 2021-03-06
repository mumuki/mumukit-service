require 'mongo'
require 'json/ext'
require 'mumukit/core'

module Mumukit
  module Service

  end
end


require 'mumukit/service/version'
require_relative './service/id_generator'
require_relative './service/database'
require_relative './service/document'
require_relative './service/document_array'
require_relative './service/document_not_found_error'
require_relative './service/document_validation_error'
require_relative './service/collection'
require_relative './service/env'
