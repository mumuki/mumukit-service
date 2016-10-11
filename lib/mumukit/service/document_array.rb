module Mumukit::Service
  class DocumentArray
    delegate :each, to: :raw
    attr_accessor :raw

    include Enumerable

    def initialize(raw, options={})
      @raw = raw
      @default_key = options[:default_key]
    end

    def as_json(options={})
      {}.tap do |json|
        json[array_key] = raw.as_json(self.options.merge(options))
      end
    end

    def array_key
      @default_key || key
    end

    def options
      {}
    end

    private

    def key
      :array
    end

  end

  JsonArrayWrapper = DocumentArray
end

