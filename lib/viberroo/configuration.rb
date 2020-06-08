module Viberroo
  class << self
    # Accessor for global configuration.
    attr_accessor :config
  end

  # Yields the global configuration to a block. Returns existing configuration if one was defined earlier.
  # @yield [Configuration] global configuration
  #
  # @example
  #     RSpec.configure do |config|
  #       config.auth_token = 'syEsp8e0'
  #     end
  # @see Viberroo::Configuration
  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end

  # Stores runtime configuration information.
  class Configuration
    attr_accessor :logger, :auth_token, :parse_response_body

    def initialize
      # Stores Viber API authentication token. Necessary for the bot to send API requests.
      @auth_token = nil

      # Specifies logger.
      @logger = Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, _, msg|
        "[#{datetime}] #{severity} Viberroo::Bot #{msg}\n"
      end

      # Specifies whether to parse request response body.
      @parse_response_body = true
    end
  end
end
