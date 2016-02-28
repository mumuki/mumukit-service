module Mumukit::Service
  class Slug
    attr_accessor :organization, :repository

    def initialize(organization, repository)
      @organization = organization
      @repository = repository
    end

    def to_s
      "#{organization}/#{repository}"
    end

    def bibliotehca_guide_web_hook_url
      "http://bibliotheca.mumuki.io/guides/import/#{to_s}"
    end

    def bibliotehca_book_web_hook_url
      "http://bibliotheca.mumuki.io/books/import/#{to_s}"
    end

    def classroom_course_url
      "http://classroom.mumuki.io/courses/#{to_s}"
    end

    def self.from(slug)
      validate_slug! slug

      self.new *slug.split('/')
    end

    private

    def self.validate_slug!(slug)
      unless slug =~ /.*\/.*/
        raise Mumukit::Service::InvalidSlugFormatError, 'Slug must be in organization/repository format'
      end
    end
  end
end



