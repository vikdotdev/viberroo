module Viberroo
  ##
  # This class' methods serve as declarative wrappers with predefined types for
  # each message type Viber API offers.
  #
  # @see https://developers.viber.com/docs/api/rest-bot-api/#message-types
  #
  class Message
    ##
    # Simple text message.
    #
    # @example
    #     message = Viberroo::Message.plain(text: 'Hello there!')
    #
    # @param [Hash] params
    # @option params [String] text **Required**.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#text-message
    #
    def self.plain(params)
      { type: :text }.merge(params)
    end

    ##
    # The Rich Media message type allows sending messages with pre-defined layout,
    # including height (rows number), width (columns number), text, images and buttons.
    #
    # @example Send a rich media
    #     search = Button.reply({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/search',
    #       Text: 'Search something...'
    #     }
    #
    #     locate = Button.reply({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/near_me'
    #     }
    #
    #     browse = Button.url({
    #       Columns: 4,
    #       Rows: 2,
    #       ActionBody: 'parrot.live',
    #       Text: 'Browse something wierd'
    #     }
    #
    #     @bot.send_rich_media(
    #       rich_media: {
    #         ButtonsGroupColumns: 4,
    #         ButtonsGroupRows: 6,
    #         Buttons: [search, locate, browse]
    #       }
    #     )
    #
    # @param [Hash] params
    # @option params [Hash] rich_media
    # @option params [Integer] rich_media.ButtonsGroupColumns Number of columns per carousel content block. Possible values 1 - 6. **API Default**: 6.
    # @option params [Integer] rich_media.ButtonsGroupRows Number of rows per carousel content block. Possible values 1 - 7. **API Default**: 7.
    # @option params [Hash] rich_media.Buttons Array of buttons. Max of 6 * `ButtonsGroupColumns` * `ButtonsGroupRows`.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#rich-media-message--carousel-content-message
    #
    def self.rich(params)
      { type: :rich_media, min_api_version: 2 }.merge(params)
    end

    ##
    # Location message.
    #
    # @example
    #     message = Message.location(location: { lat: '48.9215', lon: '24.7097' })
    #
    # @param [Hash] params
    # @option params [Hash] location
    # @option params [Float] location.lat **Required**. Latitude
    # @option params [Float] location.lon **Required**. Longitude
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#location-message
    #
    def self.location(params)
      { type: :location }.merge(params)
    end

    ##
    # Picture message.
    #
    # @note Max image size: 1MB on iOS, 3MB on Android.
    #
    # @param [Hash] params
    # @option params [String] media  **Required**. Image URL. Allowed extensions: .jpeg, .png .gif. Animated GIFs can be sent as URL messages or file messages.
    # @option params [String] text **Optional**. Max 120 characters.
    # @option params [String] thumbnail **Optional**. Thumbnail URL. Max size 100 kb. Recommended: 400x400.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#picture-message
    #
    def self.picture(params = {})
      { type: :picture, text: '' }.merge(params)
    end

    ##
    # Video message.
    #
    # @note Max video size is 26MB.
    #
    # @param [Hash] params
    # @option params [String] media  **Required**. URL of the video (MP4, H264). Only MP4 and H264 are supported.
    # @option params [Integer] size **Required**. Size of the video in bytes.
    # @option params [Integer] duration **Optional**. Duration in seconds. Max value - 180.
    # @option params [String] thumbnail **Optional**. Thumbnail URL. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#video-message
    #
    def self.video(params = {})
      { type: :video }.merge(params)
    end

    ##
    # File message.
    #
    # @note Max file size is 50MB.
    #
    # @param [Hash] params
    # @option params [String] media  **Required**. File URL.
    # @option params [Integer] size **Required**. File size in bytes.
    # @option params [String] file_name **Required**. Name of the file, should include extension. Max 256 characters (including extension).
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#file-message
    # @see https://developers.viber.com/docs/api/rest-bot-api/#forbiddenFileFormats
    #
    def self.file(params = {})
      { type: :file }.merge(params)
    end

    ##
    # Contact message.
    #
    # @param [Hash] params
    # @option params [Hash] contact
    # @option params [Float] contact.name **Required**. Name of the contact. Max 28 characters.
    # @option params [Float] contact.phone_number **Required**. Phone number of the contact. Max 18 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#contact-message
    #
    def self.contact(params = {})
      { type: :contact }.merge(params)
    end

    ##
    # URL message.
    #
    # @param [Hash] params
    # @option params [String] media  **Required**. Max 2000 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#url-message
    #
    def self.url(params = {})
      { type: :url }.merge(params)
    end

    ##
    # Sticker message.
    #
    # @param [Hash] params
    # @option params [Integer] sticker_id **Required**. Max 2000 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#sticker-message
    # @see https://developers.viber.com/docs/tools/sticker-ids/
    #
    def self.sticker(params = {})
      { type: :sticker }.merge(params)
    end
  end
end
