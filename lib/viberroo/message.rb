module Viberroo
  module Message
    # TODO: add list of keys that is mandatory at any time, throw exceptions
    # and log errors if not found
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
        normalize({ receiver: @response.user_id }.merge(params)),
        @header
      )
    end

    def normalize(params)
      params.delete_if { |_, v| v.nil? }
    end
  end
end
