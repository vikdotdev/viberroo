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
    #         # For example, params contain the following:
    #         # { foo: { bar: { baz: :boo }}}
    #         @response = Viberroo::Response.new(params.permit!)
    #         # Those can be accessed through params:
    #         puts @response.params.foo
    #         # Or directly:
    #         puts @response.foo
    #         puts @response.foo.bar
    #         puts @response.foo.bar.baz
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

    def method_missing(method)
      params.public_send(method)
    end
  end
end
