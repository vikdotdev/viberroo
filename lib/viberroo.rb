require 'json'
require 'viberroo/configuration'
require 'viberroo/message'
require 'viberroo/input'
require 'viberroo/response'
require 'viberroo/bot'
require 'logger'

module Viberroo
  module URL
    API               = 'https://chatapi.viber.com/pa'.freeze
    WEBHOOK           = "#{API}/set_webhook".freeze
    MESSAGE           = "#{API}/send_message".freeze
    BROADCAST_MESSAGE = "#{API}/broadcast_message".freeze
    GET_ACCOUNT_INFO  = "#{API}/get_account_info".freeze
    GET_USER_DETAILS  = "#{API}/get_user_details".freeze
    GET_ONLINE        = "#{API}/get_online".freeze
  end
end
