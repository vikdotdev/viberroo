require 'recursive-open-struct'

module Viberroo
  class Response
    class << self
      def init(params)
        @@os = RecursiveOpenStruct.new params.to_h
        @@os.user_id = user_id
        @@os
      end

      private

      def user_id
        case @@os.event
        when 'conversation_started', 'subscribed'
          @@os.user.id
        when 'unsubscribed', 'delivered', 'seen', 'failed'
          @@os.user_id
        when 'message'
          @@os.sender.id
        end
      end
    end
  end
end
