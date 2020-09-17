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
    # @param [String] text
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#text-message
    #
    def self.plain(text:)
      { type: :text, text: text }
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
    #     })
    #
    #     locate = Button.reply({
    #       Columns: 4,
    #       Rows: 3,
    #       ActionBody: '/near_me'
    #     })
    #
    #     browse = Button.url({
    #       Columns: 4,
    #       Rows: 2,
    #       ActionBody: 'parrot.live',
    #       Text: 'Browse something wierd'
    #     })
    #
    #     @bot.send_rich_media(
    #       buttons: [search, locate, browse],
    #       columns: 4,
    #       rows: 6,
    #       alt_text: 'This type of content is not supported on your device!'
    #     )
    #
    # @param buttons [Array] Array of buttons. Max of 6 * `ButtonsGroupColumns` * `ButtonsGroupRows`.
    # @param columns [Integer] Number of columns per carousel content block. Possible values 1 - 6.
    # @param rows [Integer] Number of rows per carousel content block. Possible values 1 - 7.
    # @param alt_text [String]
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#rich-media-message--carousel-content-message
    #
    def self.rich(buttons:, rows: 7, columns: 6, alt_text: nil)
      { type: :rich_media,
        min_api_version: 2,
        alt_text: alt_text,
        rich_media: {
          ButtonsGroupColumns: columns,
          ButtonsGroupRows: rows,
          Buttons: buttons
        }
      }
    end

    ##
    # Location message.
    #
    # @example
    #     message = Message.location(lat: '48.9215', lon: '24.7097')
    #
    # @param lat [Float] Latitude
    # @param lon [Float] Longitude
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#location-message
    #
    def self.location(lat:, lon:)
      { type: :location, location: { lat: lat, lon: lon } }
    end

    ##
    # Picture message.
    #
    # @note Max image size: 1MB on iOS, 3MB on Android.
    #
    # @param url [String] Image URL. Allowed extensions: .jpeg, .png .gif. Animated GIFs can be sent as URL messages or file messages.
    # @param text [String] Max 120 characters.
    # @param thumbnail [String] Thumbnail URL. Max size 100 kb. Recommended: 400x400.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#picture-message
    #
    def self.picture(url:, text: nil, thumbnail: nil)
      { type: :picture, url: url, text: text || '', thumbnail: thumbnail }
    end

    ##
    # Video message.
    #
    # @note Max video size is 26MB.
    #
    # @param url [String]  URL of the video (MP4, H264). Only MP4 and H264 are supported.
    # @param size [Integer] Size of the video in bytes.
    # @param thumbnail [String] Thumbnail URL. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported.
    # @param duration [Integer] Duration in seconds. Max value - 180.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#video-message
    #
    def self.video(url:, size:, thumbnail: nil, duration: nil)
      { type: :video, url: url, size: size, thumbnail: thumbnail, duration: duration }
    end

    ##
    # File message.
    #
    # @note Max file size is 50MB.
    #
    # @param url [String] File URL.
    # @param size [Integer] File size in bytes.
    # @param name [String] Name of the file, should include extension. Max 256 characters (including extension).
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#file-message
    # @see https://developers.viber.com/docs/api/rest-bot-api/#forbiddenFileFormats
    #
    def self.file(url:, size:, name:)
      { type: :file, url: url, size: size, name: name }
    end

    ##
    # Contact message.
    #
    # @param name [String] Name of the contact. Max 28 characters.
    # @param phone [String] Phone number of the contact. Max 18 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#contact-message
    #
    def self.contact(name:, phone:)
      { type: :contact, contact: { name: name, phone: phone } }
    end

    ##
    # URL message.
    #
    # @param path [String] Max 2000 characters.
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#url-message
    #
    def self.url(path)
      { type: :url, media: path }
    end

    ##
    # Sticker message.
    #
    # @param id [Integer]
    #
    # @return [Hash]
    #
    # @see https://developers.viber.com/docs/api/rest-bot-api/#sticker-message
    # @see https://developers.viber.com/docs/tools/sticker-ids/
    #
    def self.sticker(id:)
      { type: :sticker, sticker_id: id }
    end
  end
end
