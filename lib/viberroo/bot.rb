module Viberroo
  class Bot
    def initialize(token:, callback: nil)
      @headers = { 'X-Viber-Auth-Token': token, 'Content-Type': 'application/json' }
      @callback = callback
    end

    def set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)
      request(URL::WEBHOOK, url: url, event_types: event_types,
              send_name: send_name,
              send_photo: send_photo)
    end

    def set_webhook!(url:, event_types: nil, send_name: nil, send_photo: nil)
      parse set_webhook(url: url, event_types: event_types,
                        send_name: send_name,
                        send_photo: send_photo)
    end

    def remove_webhook
      request(URL::WEBHOOK, url: '')
    end

    def remove_webhook!
      parse remove_webhook
    end

    def send(message:, keyboard: {})
      request(URL::MESSAGE,
              { receiver: @callback&.user_id }.merge(message).merge(keyboard))
    end

    def send!(message:, keyboard: {})
      parse self.send(message: message, keyboard: keyboard)
    end

    def broadcast(message:, to:)
      request(URL::BROADCAST_MESSAGE, message.merge(broadcast_list: to))
    end

    def broadcast!(message:, to:)
      parse broadcast(message: message, to: to)
    end

    def get_account_info
      request(URL::GET_ACCOUNT_INFO)
    end

    def get_account_info!
      parse get_account_info
    end

    def get_user_details(id:)
      request(URL::GET_USER_DETAILS, id: id)
    end

    def get_user_details!(id:)
      parse get_user_details(id: id)
    end

    def get_online(ids:)
      request(URL::GET_ONLINE, ids: ids)
    end

    def get_online!(ids:)
      parse get_online(ids: ids)
    end

    private

    def request(url, params = {})
      Faraday.post(url, compact(params).to_json, @headers)
    end

    def parse(request)
      JSON.parse(request.body)
    end

    def compact(params)
      params.delete_if { |_, v| v.nil? }
    end
  end
end
