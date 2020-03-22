module Viberroo
  class Bot
    include Message

    def initialize(token:, user: {})
      @webhook_url = "#{API_URL}/set_webhook"
      @message_url = "#{API_URL}/send_message"
      @header = { 'X-Viber-Auth-Token': token }
      @user = user
    end

    def set_webhook(params)
      Faraday.post(@webhook_url, params.to_json, @header)
    end
  end
end
