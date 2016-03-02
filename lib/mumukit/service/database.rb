require 'yaml'
require 'erb'

module Mumukit::Service
  module Database
    def new_database_client(database)
      Mongo::Client.new(
          ["#{config[:host]}:#{config[:port]}"],
          database: database,
          user: config[:user],
          password: config[:password])
    end

    def config
      environment = ENV['RACK_ENV'] || 'development'
      @config ||= read_interpolated_yaml('config/database.yml').with_indifferent_access[environment]
    end

    def read_interpolated_yaml(filename)
      YAML.load(ERB.new(File.read(filename)).result)
    end

    def clean!
      client.collections.each(&:drop)
    end
  end
end