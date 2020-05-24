module Viberroo
  class Message
    def self.plain(params)
      { type: :text }.merge(params)
    end

    def self.rich(params)
      { type: :rich_media, min_api_version: 2 }.merge(params)
    end

    def self.location(params)
      { type: :location }.merge(params)
    end

    def self.picture(params = {})
      { type: :picture, text: '' }.merge(params)
    end

    def self.video(params = {})
      { type: :video }.merge(params)
    end

    def self.file(params = {})
      { type: :file }.merge(params)
    end

    def self.contact(params = {})
      { type: :contact }.merge(params)
    end

    def self.url(params = {})
      { type: :url }.merge(params)
    end

    def self.sticker(params = {})
      { type: :sticker }.merge(params)
    end
  end
end
