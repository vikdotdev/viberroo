module Viberroo
  module Message
    def send_message(params = {})
      dispatch({
        type: :text
      }.merge(params))
    end

    def send_rich_media(params = {})
      dispatch({
        type: :rich_media,
        min_api_version: 2
      }.merge(params))
    end

    def send_location(params = {})
      dispatch({
        type: :location,
        min_api_version: 3
      }.merge(params))
    end

    private

    def dispatch(params)
      Faraday.post(
        @message_url,
        normalize({ receiver: user_id }.merge(params)),
        @header
      )
    end

    def normalize(params)
      params.delete_if { |_, v| v.nil? }.to_json
    end

    def user_id
      case @response.event
      when 'message'
        @response.sender.id
      when 'conversation_started'
        @response.user.id
      end
    end
  end
end
