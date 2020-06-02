module Viberroo
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end

  class Configuration
    attr_accessor :logger, :auth_token

    def initialize
      @auth_token = nil

      @logger = Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, _, msg|
        "[#{datetime}] #{severity} Viberroo::Bot #{msg}\n"
      end
    end
  end
end
