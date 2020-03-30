module Viberroo
  class Bot
    include Message

    def initialize(token:, response: {})
      @webhook_url = "#{API_URL}/set_webhook"
      @message_url = "#{API_URL}/send_message"
      @headers = { 'X-Viber-Auth-Token': token, 'Content-Type': 'application/json' }
      @response = response
    end

    def set_webhook(params)
      Faraday.post(@webhook_url, params.to_json, @headers)
    end

    def remove_webhook
      Faraday.post(@webhook_url, { url: '' }.to_json, @headers)
    end
  end
end
