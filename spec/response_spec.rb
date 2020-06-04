require 'spec_helper'

RSpec.describe Viberroo::Response do
  context 'on webhook event' do
    let(:params) { webhook_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to be_nil }
    end
  end

  context 'on conversation_started event' do
    let(:params) { conversation_started_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user][:id]) }
    end
  end

  context 'on subscribed event' do
    let(:params) { subscribed_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user][:id]) }
    end
  end

  context 'on unsubscribed event' do
    let(:params) { unsubscribed_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user_id]) }
    end
  end

  context 'on delivered event' do
    let(:params) { delivered_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user_id]) }
    end
  end

  context 'on seen event' do
    let(:params) { seen_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user_id]) }
    end
  end

  context 'on failed event' do
    let(:params) { failed_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:user_id]) }
    end
  end

  context 'on message event' do
    let(:params) { message_event_params }

    describe 'params' do
      subject { Viberroo::Response.new(params).params }
      it { is_expected.to be_a(RecursiveOpenStruct) }
    end

    describe 'user_id' do
      subject { Viberroo::Response.new(params).user_id }
      it { is_expected.to eq(params[:sender][:id]) }
    end
  end
end
