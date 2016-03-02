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
      @config ||= YAML.load(ERB.new(File.read('config/database.yml')).result).with_indifferent_access[environment]
    end

    def clean!
      client.collections.each(&:drop)
    end
  end
end