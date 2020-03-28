module Viberroo
  module Input
    class Button
      def self.reply(params = {})
        { ActionType: 'reply' }.merge(params)
      end

      def self.url(params = {})
        { ActionType: 'open-url' }.merge(params)
      end

      def self.location_picker(params = {})
        { ActionType: 'location-picker',
          min_api_version: 3
        }.merge(params)
      end

      def self.share_phone(params = {})
        { ActionType: 'share-phone',
          min_api_version: 3
        }.merge(params)
      end

      def self.none(params = {})
        { ActionType: 'none' }.merge(params)
      end
    end

    def keyboard(params = {})
      { Type: 'keyboard' }.merge(params)
    end
  end
end
