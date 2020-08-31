require 'recursive-open-struct'

module Viberroo
  ##
  # Wraps callback response and provides helper methods for easier parameter
  # access.
  class Response

    ##
    # Accessor for response parameters.
    attr_reader :params

    ##
    # @example
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
    # @param [Hash] params Parameters from API callback.
    #
    def initialize(params)
      @params = RecursiveOpenStruct.new(params.to_h)
    end

    ##
    # Unifies user id access. Different callback events return user id differently.
    # This method unifies user id access interface based on callback event type.
    # Original user id params remain available in `params` attribute reader.
    # @return [Integer || nil]
    #
    def user_id
      case @params.event
      when 'conversation_started', 'subscribed'
        @params.user.id
      when 'unsubscribed', 'delivered', 'seen', 'failed'
        @params.user_id
      when 'message'
        @params.sender.id
      else
        @params.dig(:user, :id)
      end
    end
  end
end
