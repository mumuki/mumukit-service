module Mumukit::Service
  module Collection

    def method_missing(name, *args, &block)
      mongo_collection.send(name, *args, &block)
    end

    def all
      project
    end

    def count
      mongo_collection.find.count
    end

    def any?(criteria)
      mongo_collection.find(criteria).count > 0
    end

    def exists?(id)
      any?(id: id)
    end

    def delete!(id)
      mongo_collection.delete_one(id: id)
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(args)
      _find_by(args).
          try { |it| wrap it }
    end

    def find!(id)
      find_by!(id: id)
    end

    def find_by!(args)
      _find_by(args).
          tap { |first| validate_presence(args, first) }.
          try { |it| wrap it }
    end

    def insert!(json)
      json.validate!

      with_id new_id do |id|
        mongo_collection.insert_one json.raw.merge(id)
      end
    end

    def uniq(key, filter, uniq_value)
      distinct(key, filter).uniq { |result| result[uniq_value] }
    end

    def where(args, projection={})
      raw = find_projection(args, projection).map { |it| wrap it }
      wrap_array raw
    end

    def first_by(args, options, projection={})
      find_projection(args, projection).sort(options).first.try{ |it| wrap(it) }
    end

    def order_by(args, options, projection={})
      raw = find_projection(args, projection).sort(options).map { |it| wrap(it) }
      wrap_array raw
    end

    private

    def validate_presence(args, first)
      raise Mumukit::Service::DocumentNotFoundError, "document #{args.to_json} not found" unless first
    end

    def _find_by(args)
      mongo_collection.find(args).projection(_id: 0).first
    end

    def mongo_collection
      mongo_database.client[mongo_collection_name]
    end

    def find_projection(args={}, projection={})
      mongo_collection.find(args).projection(projection.merge(_id: 0))
    end

    def project(&block)
      raw = find_projection.map { |it| wrap it }

      raw = raw.select(&block) if block_given?

      wrap_array raw
    end

    def wrap(mongo_document)
      Mumukit::Service::Document.new mongo_document
    end

    def wrap_array(array)
      Mumukit::Service::DocumentArray.new array
    end

    def new_id
      Mumukit::Service::IdGenerator.next
    end

    def with_id(id)
      id_object = {id: id}
      yield id_object
      id_object
    end
  end
end