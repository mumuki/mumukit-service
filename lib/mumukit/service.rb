module Mumukit
  module Service

  end
end

require 'mumukit/service/version'
require_relative './service/id_generator'
require_relative './service/slug'
require_relative './service/invalid_slug_format_error'
require_relative './service/json_wrapper'
require_relative './service/json_array_wrapper'
require_relative './service/document_not_found_error'
require_relative './service/document_validation_error'
require_relative './service/collection'
