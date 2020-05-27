require 'spec_helper'

RSpec.describe Viberroo::Bot do
  let(:token) { '1234567890' }
  let(:headers) { { 'X-Viber-Auth-Token': token } }
  let(:response) do
    Viberroo::Response.init(
      event: 'message',
      sender: { id: '01234=' }
    )
  end
  let(:bot) { Viberroo::Bot.new(token: token, response: response) }

  describe '#set_webhook' do
    let!(:url) { Viberroo::URL::WEBHOOK }
    let!(:params) do
      { url: 'http://my.host.com', event_types: %w[conversation_started] }
    end

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: params, headers: headers)
      bot.set_webhook(params)

      expect(request).to have_been_made.once
    end
  end

  describe '#remove_webhook' do
    let!(:url) { Viberroo::URL::WEBHOOK }
    let!(:params) { { url: '' } }

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: params, headers: headers)

      bot.remove_webhook
      expect(request).to have_been_made.once
    end
  end

  describe '#send' do
    let!(:url) { Viberroo::URL::MESSAGE }
    let!(:message) do
      {
        text: 'hello',
        event: 'message',
        sender: { id: '1234=' },
        receiver: response.user_id
      }
    end

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: message, headers: headers)

      bot.send(message: message)
      expect(request).to have_been_made.once
    end
  end

  describe '#broadcast message'

  describe '#get_account_info' do
    let!(:url) { Viberroo::URL::GET_ACCOUNT_INFO }

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: {}, headers: headers)

      bot.get_account_info
      expect(request).to have_been_made.once
    end
  end

  describe '#get_user_details' do
    let!(:url) { Viberroo::URL::GET_USER_DETAILS }
    let!(:params) { { id: '1234567890=' } }

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: params, headers: headers)

      bot.get_user_details(params)
      expect(request).to have_been_made.once
    end
  end

  describe '#get_online' do
    let!(:url) { Viberroo::URL::GET_ONLINE }
    let!(:params) { { ids: %w[1234= 2532= 8587=] } }

    it 'makes a request with correct url, body and headers' do
      request = stub_request(:post, url).with(body: params, headers: headers)

      bot.get_online(params)
      expect(request).to have_been_made.once
    end
  end
end
