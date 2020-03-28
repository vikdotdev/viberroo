require 'spec_helper'

RSpec.describe Viberroo::Bot do
  let(:bot) { Viberroo::Bot.new(token: token) }

  describe '#set_webhook' do
    it 'makes a request with correct url, body and header' do
      stub = stub_request(:post, webhook_url).with(body: set_webhook_params, headers: headers)

      bot.set_webhook(set_webhook_params)
      expect(stub).to have_been_made.once
    end
  end

  describe '#remove_webhook' do
    it 'requests API with correct params'
  end
end
