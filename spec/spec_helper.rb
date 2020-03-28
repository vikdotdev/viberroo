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
    { text: 'my_message' }.merge(generic_params)
  end
  let(:rich_media_params) do
    generic_params
  end
  let(:location_params) do
    { 'location': { lat: '37.50', lon: '-122.20' }}.merge(generic_params)
  end
  let(:generic_params) do
    { event: 'message', sender: { id: '01234567890A=' } }
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
