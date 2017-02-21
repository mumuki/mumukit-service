module Mumukit::Service::Env
  class << self
    def atheneum_url
      ENV['MUMUKI_ATHENEUM_URL']
    end

    def bot_username
      ENV['MUMUKI_BOT_USERNAME']
    end

    def bot_email
      ENV['MUMUKI_BOT_EMAIL']
    end

    def bot_api_token
      ENV['MUMUKI_BOT_API_TOKEN']
    end
  end
end