ENV['RACK_ENV'] = 'test'

require 'mumukit/service'

Mongo::Logger.logger.level = ::Logger::INFO

RSpec::Matchers.define :json_like do |expected, options={}|
  except = options[:except] || []
  match do |actual|
    actual.as_json.with_indifferent_access.except(except) == expected.as_json.with_indifferent_access
  end

  failure_message_for_should do |actual|
    <<-EOS
    expected: #{expected.as_json} (#{expected.class})
         got: #{actual.as_json} (#{actual.class})
    EOS
  end

  failure_message_for_should_not do |actual|
    <<-EOS
    expected: value != #{expected.as_json} (#{expected.class})
         got:          #{actual.as_json} (#{actual.class})
    EOS
  end
end

module Mumukit::Test

  module Database
    extend Mumukit::Service::Database

    def self.client
      @client ||= new_database_client config[:database]
    end
  end

  module Foos
    extend Mumukit::Service::Collection

    private

    def self.mongo_collection_name
      :foos
    end

    def self.mongo_database
      Mumukit::Test::Database
    end

    def self.wrap(it)
      Mumukit::Test::Foo.new(it)
    end

    def self.wrap_array(it)
      Mumukit::Test::FooArray.new(it)
    end
  end

  class Foo < Mumukit::Service::Document

    def initialize(it)
      super(it)
    end
  end

  class FooArray < Mumukit::Service::DocumentArray
    def key
      :foos
    end
  end

end
