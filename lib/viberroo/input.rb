module Viberroo
  ##
  # This class' methods serve as declarative wrappers with predefined
  # types for UI elements such as buttons and keyboards. Buttons can be combined
  # with a keyboard or used in rich messages. Only basic parameters are
  # specified in this documentation, to see all possibilities please consult
  # official Viber API documentation.
  #
  # @see https://viber.github.io/docs/tools/keyboards/#general-keyboard-parameters
  # @see https://viber.github.io/docs/tools/keyboards/#buttons-parameters
  #
  class Input
    ##
    # A keyboard that can be attached to any message.
    #
    # @example
    #     go_somewhere = Viberroo::Input.url_button({
    #       Columns: 3,
    #       Rows: 2,
    #       Text: 'Mystery link',
    #       ActionBody: 'somewhere.com'
    #     })
    #
    #     keyboard = Input.keyboard(Buttons: [go_somewhere])
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#general-keyboard-parameters
    #
    def self.keyboard(params)
      { keyboard: { Type: 'keyboard' }.merge(params) }
    end

    ##
    # A reply button, when tapped sends it's body as a message.
    #
    # @example
    #     button = Viberroo::Input.reply_button({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/search_cookies',
    #       Text: 'I want some cookies.'
    #     }
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#buttons-parameters
    #
    def self.reply_button(params)
      { ActionType: 'reply' }.merge(params)
    end

    ##
    # A URL button, when tapped opens specified URL.
    #
    # @example
    #     button = Viberroo::Input.url_button({
    #       Columns: 4,
    #       Rows: 2,
    #       ActionBody: 'parrot.live',
    #       Text: 'Browse something weird'
    #     }
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#buttons-parameters
    #
    def self.url_button(params)
      { ActionType: 'open-url' }.merge(params)
    end

    ##
    # @note Not supported on desktop.
    #
    # Location picker button, gives ability to pick a location on the map.
    #
    # @example
    #     button = Viberroo::Input.location_picker_button(lat: 48.9215, lon: 24.7097)
    #
    # @param lat [Float] Latitude.
    # @param lon [Float] Longitude.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#buttons-parameters
    #
    def self.location_picker_button(lat:, lon:)
      { ActionType: 'location-picker',
        location: { lat: lat, lon: lon },
        min_api_version: 3
      }.merge(params)
    end

    ##
    # @note Not supported on desktop.
    #
    # Share phone button.
    #
    # @example
    #   button = Viberroo::Input.share_phone_button(name: 'Gwythyr', phone: '12343214')
    #
    # @param name [String] Name of the contact. Max 28 characters.
    # @param phone [String] Phone number of the contact. Max 18 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#buttons-parameters
    #
    def self.share_phone_button(name:, phone:)
      { ActionType: 'share-phone',
        min_api_version: 3
        contact: { name: name, phone: phone }
      }
    end

    ##
    # A button that does nothing, for decoration purposes.
    #
    # @example
    #   button = Viberroo::Input.none_button(Text: 'Purely decorative.')
    #
    # @see https://developers.viber.com/docs/tools/keyboards/#buttons-parameters
    #
    def self.none_button(params = {})
      { ActionType: 'none' }.merge(params)
    end
  end
end
