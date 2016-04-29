ENV['RACK_ENV'] = 'test'

require 'mumukit/service'

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

  class Foo < Mumukit::Service::JsonWrapper

    def initialize(it)
      super(it.except(:id))
    end
  end

  class FooArray < Mumukit::Service::JsonArrayWrapper
    def key
      :foos
    end
  end

end
