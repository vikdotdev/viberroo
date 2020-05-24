module Viberroo
  class Input
    def self.keyboard(params)
      { keyboard: { Type: 'keyboard' }.merge(params) }
    end

    def self.reply_button(params)
      { ActionType: 'reply' }.merge(params)
    end

    def self.url_button(params)
      { ActionType: 'open-url' }.merge(params)
    end

    def self.location_picker_button(params)
      { ActionType: 'location-picker',
        min_api_version: 3
      }.merge(params)
    end

    def self.share_phone_button(params)
      { ActionType: 'share-phone',
        min_api_version: 3
      }.merge(params)
    end

    def self.none_button(params = {})
      { ActionType: 'none' }.merge(params)
    end
  end
end
