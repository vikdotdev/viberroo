require 'recursive-open-struct'

module Viberroo
  class Response
    attr_reader :params

    def initialize(params)
      warn 'DEPRECATION WARNING: Callback class will be renamed to Response in next minor release.'
      @params = RecursiveOpenStruct.new params.to_h
    end

    def user_id
      case @params.event
      when 'conversation_started', 'subscribed'
        @params.user.id
      when 'unsubscribed', 'delivered', 'seen', 'failed'
        @params.user_id
      when 'message'
        @params.sender.id
      else
        @params.dig(:user, :id)
      end
    end
  end

  class Response
    attr_reader :params

    def initialize(params)
      @params = RecursiveOpenStruct.new params.to_h
    end

    def user_id
      case @params.event
      when 'conversation_started', 'subscribed'
        @params.user.id
      when 'unsubscribed', 'delivered', 'seen', 'failed'
        @params.user_id
      when 'message'
        @params.sender.id
      else
        @params.dig(:user, :id)
      end
    end
  end
end
