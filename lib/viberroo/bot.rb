module Viberroo
  class Bot
    def initialize(token:, response: {})
      @headers = { 'X-Viber-Auth-Token': token, 'Content-Type': 'application/json' }
      @response = response
    end

    def set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)
      request(
        URL::WEBHOOK,
        url: url,
        event_types: event_types,
        send_name: send_name,
        send_photo: send_photo
      )
    end

    def remove_webhook
      request(URL::WEBHOOK, url: '')
    end

    def send(message:, keyboard: {})
      request(
        URL::MESSAGE,
        { receiver: @response.user_id }.merge(message).merge(keyboard)
      )
    end

    def broadcast(message:, to:)
      request(URL::BROADCAST_MESSAGE, message.merge(broadcast_list: to))
    end

    def get_account_info
      request(URL::GET_ACCOUNT_INFO)
    end

    def get_user_details(id:)
      request(URL::GET_USER_DETAILS, id: id)
    end

    def get_online(ids:)
      request(URL::GET_ONLINE, ids: ids)
    end

    private

    def request(url, params = {})
      Faraday.post(url, compact(params).to_json, @headers)
    end

    def compact(params)
      params.delete_if { |_, v| v.nil? }
    end
  end
end
