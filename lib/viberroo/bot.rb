require 'net/http'
require 'uri'

# Namespace for all Viberroo code.
module Viberroo

  # Used for sending requests to Viber API. Each request sends a http POST request to a particular endpoint, each returns http response.
  class Bot
    def initialize(token: nil, response: nil)
      Viberroo.configure

      @headers = {
        'X-Viber-Auth-Token': token || Viberroo.config.auth_token,
        'Content-Type': 'application/json'
      }
      @response = response
    end

    # Used to set bot webhook.
    def set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)
      request(URL::WEBHOOK, url: url, event_types: event_types,
              send_name: send_name, send_photo: send_photo)
    end

    # Used to remove bot webhook.
    def remove_webhook
      request(URL::WEBHOOK, url: '')
    end

    # Used to send messages.
    def send(message:, keyboard: {})
      request(URL::MESSAGE,
              { receiver: @response&.user_id }.merge(message).merge(keyboard))
    end

    # Used to broadcast messages.
    def broadcast(message:, to:)
      request(URL::BROADCAST_MESSAGE, message.merge(broadcast_list: to))
    end

    # Used to retrieve account info. These settings can be set in you Viber admin panel.
    def get_account_info
      request(URL::GET_ACCOUNT_INFO)
    end

    # Used to retrieve details of a particular user.
    def get_user_details(id:)
      request(URL::GET_USER_DETAILS, id: id)
    end

    # Used to get online of a list of subscribed users.
    def get_online(ids:)
      request(URL::GET_ONLINE, ids: ids)
    end

    private

    def request(url, params = {})
      uri = URI(url)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(uri, @headers)
        request.body = compact(params).to_json

        http.request(request)
      end

      Viberroo.config.logger&.info("##{caller_name} -- #{response.body}")

      Viberroo.config.parse_response_body ? JSON.parse(response.body) : response
    end

    def compact(params)
      params.delete_if { |_, v| v.nil? }
    end

    def caller_name
      caller[1][/`.*'/][1..-2]
    end
  end
end
