require 'spec_helper'

RSpec.describe Viberroo::Input do
  describe 'Button.reply' do
    it 'has correct ActionType' do
      expect(subject::Button.reply).to include({ ActionType: 'reply' })
    end
  end

  describe 'Button.url' do
    it 'has correct ActionType' do
      expect(subject::Button.url).to include({ ActionType: 'open-url' })
    end

    it 'has correct min_api_version'
  end

  describe 'Button.location_picker' do
    it 'has correct ActionType' do
      expect(subject::Button.location_picker).to include({ ActionType: 'location-picker' })
    end
  end

  describe 'Button.none' do
    it 'has correct ActionType' do
      expect(subject::Button.none).to include({ ActionType: 'none' })
    end
  end

  describe 'Button.share_phone' do
    it 'has correct ActionType' do
      expect(subject::Button.share_phone).to include({ ActionType: 'share-phone' })
    end
  end

  describe 'Input::keyboard' do
    include Viberroo::Input

    it 'has correct Type' do
      expect(keyboard).to include({ Type: 'keyboard' })
    end
  end
end
