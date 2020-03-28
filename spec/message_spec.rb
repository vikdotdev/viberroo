require 'spec_helper'

RSpec.describe Viberroo::Message do
  let(:response) { Viberroo::Response.init(message_params) }
  let(:bot) { Viberroo::Bot.new(token: token, response: response) }
  let(:receiver) { response.user_id }

  describe 'send_message' do
    it 'requests API with correct params' do
      body = hash_including(type: 'text', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_message(message_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_rich_media' do
    it 'requests API with correct params' do
      body = hash_including(type: 'rich_media', receiver: receiver, min_api_version: 2)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_rich_media(rich_media_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_location' do
    it 'requests API with correct params' do
      body = hash_including(type: 'location', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_location(location_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_picture' do
    it 'requests API with correct params' do
      body = hash_including(type: 'picture', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_picture(picture_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_url' do
    it 'requests API with correct params' do
      body = hash_including(type: 'url', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_url(url_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_video' do
    it 'requests API with correct params' do
      body = hash_including(type: 'video', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_video(video_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_file' do
    it 'requests API with correct params' do
      body = hash_including(type: 'file', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_file(file_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_contact' do
    it 'requests API with correct params' do
      body = hash_including(type: 'contact', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_contact(contact_params)
      expect(stub).to have_been_made.once
    end
  end

  describe 'send_sticker' do
    it 'requests API with correct params' do
      body = hash_including(type: 'sticker', receiver: receiver)
      stub = stub_request(:post, message_url).with(body: body, headers: headers)

      bot.send_sticker(sticker_params)
      expect(stub).to have_been_made.once
    end
  end
end
