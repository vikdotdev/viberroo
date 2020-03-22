module Viberroo
  class User
    attr_reader :message, :event, :id, :name, :avatar, :country, :language, :location

    def initialize(params)
      @event = params&.dig('event')

      case @event
      when 'message'
        @user = params&.dig('sender')
      when 'conversation_started'
        @user = params&.dig('user')
      end

      @id = @user&.dig('id')
      @message = params&.dig('message')
      @name = @user&.dig('name')
      @avatar = @user&.dig('avatar')
      @country = @user&.dig('country')
      @language = @user&.dig('language')
      @location = params&.dig('message', 'location')
    end
  end
end
