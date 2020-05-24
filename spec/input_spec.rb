require 'spec_helper'

RSpec.describe Viberroo::Input do
  subject { Viberroo::Input }

  describe '#self.reply_button' do
    it 'has correct ActionType' do
      expect(subject.reply_button({})).to include({ ActionType: 'reply' })
    end
  end

  describe '#self.url_button' do
    it 'has correct ActionType' do
      expect(subject.url_button({})).to include({ ActionType: 'open-url' })
    end
  end

  describe '#self.location_picker_button' do
    it 'has correct ActionType' do
      expect(subject.location_picker_button({})).to include({ ActionType: 'location-picker' })
    end
  end

  describe '#self.none_button' do
    it 'has correct ActionType' do
      expect(subject.none_button({})).to include({ ActionType: 'none' })
    end
  end

  describe '#self.share_phone_button' do
    it 'has correct ActionType' do
      expect(subject.share_phone_button({})).to include({ ActionType: 'share-phone' })
    end
  end

  describe '#self.keyboard' do
    it 'has correct Type' do
      expect(subject.keyboard({})).to include({ keyboard: { Type: 'keyboard' }})
    end
  end
end
