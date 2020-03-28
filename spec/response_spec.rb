require 'spec_helper'

RSpec.describe Viberroo::Response do
  describe 'init' do
    it 'returns response on set_webhook event' do
      response = subject.class.init(set_webhook_event_params)
      expect(response.user_id).to eq(nil)
      expect(response).not_to eq(nil)
    end
    it 'sets correct user_id on conversation_started event' do
      response = subject.class.init(conversation_started_event_params)
      user_id = conversation_started_event_params[:user][:id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on subscribed event' do
      response = subject.class.init(subscribed_event_params)
      user_id = subscribed_event_params[:user][:id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on unsubscribed event' do
      response = subject.class.init(unsubscribed_event_params)
      user_id = unsubscribed_event_params[:user_id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on delivered event' do
      response = subject.class.init(delivered_event_params)
      user_id = delivered_event_params[:user_id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on seen event' do
      response = subject.class.init(seen_event_params)
      user_id = seen_event_params[:user_id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on failed event' do
      response = subject.class.init(failed_event_params)
      user_id = failed_event_params[:user_id]
      expect(response.user_id).to eq(user_id)
    end
    it 'sets correct user_id on message event' do
      response = subject.class.init(message_event_params)
      user_id = message_event_params[:sender][:id]
      expect(response.user_id).to eq(user_id)
    end
  end
end
