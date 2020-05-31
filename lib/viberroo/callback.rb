require 'recursive-open-struct'

module Viberroo
  class Callback
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
