require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'
require 'byebug'
require 'viberroo'

RSpec.shared_context 'constants' do
  let(:webhook_url) { "#{Viberroo::API_URL}/set_webhook" }
  let(:message_url) { "#{Viberroo::API_URL}/send_message" }
  let(:token) { '1234567890' }
  let(:headers) { { 'X-Viber-Auth-Token': token } }
end

RSpec.shared_context 'params' do
  let(:set_webhook_params) do
    { url: 'http://my.host.com', event_types: %w[conversation_started] }
  end
  let(:message_params) do
    { text: 'my_message' }.merge(message_event_params)
  end
  let(:rich_media_params) do
    message_event_params
  end
  let(:location_params) do
    { 'location': { lat: '37.50', lon: '-122.20' } }.merge(message_event_params)
  end
  let(:message_event_params) do
    { event: 'message', sender: { id: 'message01234' } }
  end
  let(:conversation_started_event_params) do
    { event: 'conversation_started', user: { id: 'conversation01234' } }
  end
  let(:delivered_event_params) do
    { event: 'delivered', user_id: 'delivered01234' }
  end
  let(:unsubscribed_event_params) do
    { event: 'unsubscribed', user_id: 'unsubscribed01234' }
  end
  let(:subscribed_event_params) do
    { event: 'subscribed', user: { id: 'subscribed01234' } }
  end
  let(:seen_event_params) do
    { event: 'seen', user_id: 'seen01234' }
  end
  let(:failed_event_params) do
    { event: 'failed', user_id: 'failed01234' }
  end
end

RSpec.configure do |config|
  config.include_context 'constants'
  config.include_context 'params'
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
    c.syntax = :expect
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.warnings = true
  # config.profile_examples = 10
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  Kernel.srand config.seed
end
