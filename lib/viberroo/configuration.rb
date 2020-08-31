module Viberroo
  class << self
    # Accessor for global configuration.
    attr_accessor :config
  end

  ##
  # Yields the global configuration to a block. Returns existing configuration
  # if one was defined earlier.
  # @yield [Configuration] global configuration
  #
  # @example
  #     RSpec.configure do |config|
  #       config.auth_token = '445da6az1s345z78-dazcczb2542zv51a-e0vc5fva17480im9'
  #       config.parse_response_body = false
  #     end
  #
  # @see Viberroo::Configuration
  #
  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end

  ##
  # Stores runtime configuration information.
  #
  class Configuration
    ##
    # Specifies logger.
    #
    # @return [Logger]
    attr_accessor :logger

    ##
    # Stores Viber API authentication token.
    # Necessary for the bot to send API requests.
    #
    # @return [String]
    #
    # @see Bot#set_webhook
     attr_accessor :auth_token
   
    ##
    # Specifies whether to parse response body of Bot requests.
    #
    # @return [true || false]
    #
    # @see Bot
     attr_accessor :parse_response_body

    def initialize
      @auth_token = nil

      @logger = Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, _, msg|
        "[#{datetime}] #{severity} Viberroo::Bot #{msg}\n"
      end

      @parse_response_body = true
    end
  end
end
