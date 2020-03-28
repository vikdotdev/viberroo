module Viberroo
  module Message
    # TODO: add list of params that is mandatory for particular message type,
    # throw exceptions and log errors if not found

    def send_message(params = {})
      dispatch({ type: :text }.merge(params))
    end

    def send_rich_media(params = {})
      dispatch({ type: :rich_media, min_api_version: 2 }.merge(params))
    end

    def send_location(params = {})
      dispatch({ type: :location, min_api_version: 3 }.merge(params))
    end

    def send_picture(params = {})
      dispatch({ type: :picture }.merge(params))
    end

    def send_video(params = {})
      dispatch({ type: :video }.merge(params))
    end

    def send_file(params = {})
      dispatch({ type: :file }.merge(params))
    end

    def send_contact(params = {})
      dispatch({ type: :contact }.merge(params))
    end

    def send_url(params = {})
      dispatch({ type: :url }.merge(params))
    end

    # https://viber.github.io/docs/tools/sticker-ids/
    def send_sticker(params = {})
      dispatch({ type: :sticker }.merge(params))
    end

    private

    def dispatch(params)
      Faraday.post(
        @message_url,
        normalize({ receiver: @response.user_id }.merge(params)),
        @headers
      )
    end

    def normalize(params)
      params.delete_if { |_, v| v.nil? }.to_json
    end
  end
end
