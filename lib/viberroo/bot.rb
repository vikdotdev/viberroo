require 'net/http'
require 'uri'

module Viberroo
  ##
  # This class represents a server bot/client which communicates to Viber API. Each request sends a http POST request to a particular endpoint, each returns either http response, or parsed response body as specified in configuration.
  #
  # @see Configuration
  #
  class Bot
    ##
    # @example Initializing
    #     class ViberController < ApplicationController
    #       skip_before_action :verify_authenticity_token
    #
    #       def callback
    #         @response = Viberroo::Response.new(params.permit!)
    #         @bot = Viberroo::Bot.new(response: @response)
    #
    #         head :ok
    #       end
    #     end
    #
    # @param [Response] response **Required**. A callback response.
    # @param [String] token  **Optional**. Normally should be provided by `Viberroo.configure.auth_token` but is available here as a shortcut when predefined configuration is undesirable. Takes precedence over `Viberroo.configure.auth_token`.
    #
    # @see Response
    # @see Configuration
    # @see https://developers.viber.com/docs/api/rest-bot-api/#authentication-token
    #
    def initialize(response: Response.new({}), token: nil)
      Viberroo.configure

      @headers = {
        'X-Viber-Auth-Token': token || Viberroo.config.auth_token,
        'Content-Type': 'application/json'
      }
      @response = response
    end

    ##
    # Sets a webhook by making a request to `/set_webhook`. Necessary for receiving callbacks from Viber.
    # For security reasons only URLs with valid and official SSL certificate from a trusted CA will be allowed. `ngrok` is a good workaround for development convenience.
    #
    # @example Setup webhook with rake task
    #     namespace :viber do
    #       task set_webhook: :environment do
    #         Viberroo::Bot.new.set_webhook(
    #           url: 'https://<your_ngrok_public_address>/viber',
    #           event_types: %w[conversation_started subscribed unsubscribed],
    #           send_name: true,
    #           send_photo: true
    #         )
    #       end
    #     end
    #
    # @param [String] url  **Required**. HTTPs callback URL.
    # @param [Array] event_types **Optional**. Indicates the types of Viber events that the bot will receive. Leaving this parameter out will include all events. **API default**: `%w[delivered seen failed subscribed unsubscribed conversation_started]`.
    # @param [true, false] send_name **Optional**. Indicates whether or not the bot should receive the user name. **API default**: `false`.
    # @param [true, false] send_photo **Optional**. Indicates whether or not the bot should receive the user photo. **API default**: `false`.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#webhooks
    #
    def set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)
      request(URL::WEBHOOK, url: url, event_types: event_types,
                            send_name: send_name, send_photo: send_photo)
    end

    ##
    # Removes a webhook by making a request to `/set_webhook`.
    #
    # @example Remove webhook with rake task
    #   namespace :viber do
    #     task remove_webhook: :environment do
    #       Viberroo::Bot.new.remove_webhook
    #     end
    #   end
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#removing-your-webhook
    #
    # @return [Net::HTTPResponse || Hash]
    #
    def remove_webhook
      request(URL::WEBHOOK, url: '')
    end

    ##
    # Sends a message to a user by making a request to `/send_message`.
    #
    # @example Send a plain message
    #     go_somewhere = Viberroo::Input.url_button({
    #       Columns: 3,
    #       Rows: 2,
    #       Text: 'Mystery link',
    #       ActionBody: 'somewhere.com'
    #     })
    #
    #     keyboard = Viberroo::Input.keyboard(Buttons: [go_somewhere])
    #     message = Viberroo::Message.plain(text: 'Click if you dare.')
    #
    #     @bot.send(message: message, keyboard: keyboard)
    #
    # @example Send a rich media
    #     search = Viberroo::Input.reply_button({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/search',
    #       Text: 'Search something...'
    #     }
    #
    #     locate = Viberroo::Input.reply_button({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/near_me'
    #     }
    #
    #     browse = Viberroo::Input.url_button({
    #       Columns: 4,
    #       Rows: 2,
    #       ActionBody: 'parrot.live',
    #       Text: 'Browse something wierd'
    #     }
    #
    #     rich_message = Viberroo::Message.rich(rich_media: { ButtonsGroupColumns: 4,
    #                                                         ButtonsGroupRows: 6,
    #                                                         Buttons: [search, locate, browse] })
    #
    #     @bot.send(message: rich_message)
    #
    # @param [Hash] message **Required**. One of the message types to send.
    # @param [Hash] keyboard **Optional**. A keyboard that can be attached to a message.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see Message
    # @see Input
    # @see https://developers.viber.com/docs/api/rest-bot-api/#send-message
    # @see https://viber.github.io/docs/tools/keyboards/#buttons-parameters
    # @see https://developers.viber.com/docs/api/rest-bot-api/#keyboards
    #
    def send_message(message, keyboard: {})
      request(URL::MESSAGE, { receiver: @response.user_id }.merge(message, keyboard))
    end

    # @deprecated Use {#send_message} instead.
    def send(message:, keyboard: {})
      Viberroo.config.logger.info(<<~WARNING)
        DEPRECATION WARNING: Bot#send method is going to be removed in the next
        minor release. Use Bot#send_message instead.
      WARNING

      send_message(message, keyboard: keyboard)
    end

    ##
    # @note This request has a rate limit of 500 requests in a 10 seconds window.
    #
    # Broadcasts a messages to subscribed users by making a request to `/broadcast_message`.
    #
    # @example Broadcast simple message
    #     message = Viberroo::Message.plain(text: 'Howdy.')
    #     response = @bot.broadcast(message: message, to: ViberSubscriber.sample(500).pluck(:viber_id))
    #
    # @param [Hash] message **Required**. One of the message types to broadcast.
    # @param [Array] to **Required**. List of user ids to broadcast to. Specified users need to be subscribed.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see Message
    # @see Input
    # @see https://developers.viber.com/docs/api/rest-bot-api/#broadcast-message
    #
    def broadcast(message:, to:)
      request(URL::BROADCAST_MESSAGE, message.merge(broadcast_list: to))
    end

    ##
    # Retrieves account info by making a request to `/get_account_info`. These settings can be set in you Viber admin panel.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#get-account-info
    #
    def get_account_info
      request(URL::GET_ACCOUNT_INFO)
    end

    ##
    # @note This request can be sent twice during a 12 hours period for each user ID.
    #
    #
    # @example
    #     response = @bot.get_user_details(id: ViberSubscriber.sample.viber_id)
    #
    # Retrieves details of particular user by making a request to `/get_user_details`.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#get-user-details
    #
    def get_user_details(id:)
      request(URL::GET_USER_DETAILS, id: id)
    end

    ##
    # @note The API supports up to 100 user id per request and those users must be subscribed to the account.
    #
    # Retrieves a list of user status by making a request to `get_online`.
    #
    #
    # @example
    #     response = @bot.get_online(ids: ViberSubscriber.sample(100).pluck(:viber_id))
    #
    # @param [Array] ids **Required**. List of user ids.
    #
    # @return [Net::HTTPResponse || Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#get-online
    #
    def get_online(ids:)
      request(URL::GET_ONLINE, ids: ids)
    end

    private

    # @!visibility private
    def request(url, params = {})
      uri = URI(url)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(uri, @headers)
        request.body = compact(params).to_json

        http.request(request)
      end

      Viberroo.config.parse_response_body ? JSON.parse(response.body) : response
    end

    # @!visibility private
    # Extends Ruby version compability from 2.4 to 2.3.
    def compact(params)
      params.delete_if { |_, v| v.nil? }
    end

    # @!visibility private
    def caller_name
      caller[1][/`.*'/][1..-2]
    end
  end
end
