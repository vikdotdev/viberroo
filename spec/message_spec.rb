require 'spec_helper'

RSpec.describe Viberroo::Message do
  describe '#text' do
    subject { Viberroo::Message.plain(text_params) }

    it { is_expected.to include({ type: :text }) }
  end

  describe '#rich' do
    subject { Viberroo::Message.rich(rich_params) }

    it { is_expected.to include({ type: :rich_media }) }
    it { is_expected.to include({ min_api_version: 2 }) }
  end

  describe '#location' do
    subject { Viberroo::Message.location(location_params) }

    it { is_expected.to include({ type: :location }) }
  end

  describe '#picture' do
    subject { Viberroo::Message.picture(picture_params) }

    it { is_expected.to include({ type: :picture }) }
  end

  describe '#url' do
    subject { Viberroo::Message.video(video_params) }

    it { is_expected.to include({ type: :video }) }
  end

  describe '#video' do
    subject { Viberroo::Message.file(file_params) }

    it { is_expected.to include({ type: :file }) }
  end

  describe '#file' do
    subject { Viberroo::Message.contact(contact_params) }

    it { is_expected.to include({ type: :contact }) }
  end

  describe '#contact' do
    subject { Viberroo::Message.url(url_params) }

    it { is_expected.to include({ type: :url }) }
  end

  describe '#sticker' do
    subject { Viberroo::Message.sticker(sticker_params) }

    it { is_expected.to include({ type: :sticker }) }
  end
end
