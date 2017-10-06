# Copyright 2017, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'google/gax/grpc'

describe Google::Gax::Grpc do
  describe '#create_stub' do
    it 'yields constructed channel credentials' do
      mock = instance_double(GRPC::Core::ChannelCredentials)
      composed_mock = instance_double(GRPC::Core::ChannelCredentials)
      default_creds = instance_double(Google::Auth::ServiceAccountCredentials)
      updater_proc = proc {}

      allow(Google::Auth)
        .to receive(:get_application_default).and_return(default_creds)
      allow(default_creds).to receive(:updater_proc).and_return(updater_proc)
      allow(mock).to receive(:compose).and_return(composed_mock)
      allow(GRPC::Core::ChannelCredentials).to receive(:new).and_return(mock)

      expect do |blk|
        Google::Gax::Grpc.create_stub('service', 'port', &blk)
      end.to yield_with_args('service:port', composed_mock)
    end

    it 'yields given channel' do
      mock = instance_double(GRPC::Core::Channel)
      expect do |blk|
        Google::Gax::Grpc.create_stub('service', 'port', channel: mock, &blk)
      end.to yield_with_args('service:port', nil, channel_override: mock)
    end

    it 'yields given channel credentials' do
      mock = instance_double(GRPC::Core::ChannelCredentials)
      expect do |blk|
        Google::Gax::Grpc.create_stub('service', 'port', chan_creds: mock, &blk)
      end.to yield_with_args('service:port', mock)
    end

    it 'yields channel credentials composed of the given updater_proc' do
      chan_creds = instance_double(GRPC::Core::ChannelCredentials)
      composed_chan_creds = instance_double(GRPC::Core::ChannelCredentials)
      call_creds = instance_double(GRPC::Core::CallCredentials)
      updater_proc = proc {}

      allow(GRPC::Core::CallCredentials)
        .to receive(:new).with(updater_proc).and_return(call_creds)
      allow(GRPC::Core::ChannelCredentials)
        .to receive(:new).and_return(chan_creds)
      allow(chan_creds)
        .to receive(:compose).with(call_creds).and_return(composed_chan_creds)
      expect do |blk|
        Google::Gax::Grpc.create_stub(
          'service', 'port', updater_proc: updater_proc, &blk
        )
      end.to yield_with_args('service:port', composed_chan_creds)
    end

    it 'raise an argument error if multiple creds are passed in' do
      channel = instance_double(GRPC::Core::Channel)
      chan_creds = instance_double(GRPC::Core::ChannelCredentials)
      updater_proc = instance_double(Proc)

      expect do |blk|
        Google::Gax::Grpc.create_stub(
          'service', 'port', channel: channel, chan_creds: chan_creds, &blk
        )
      end.to raise_error(ArgumentError)

      expect do |blk|
        Google::Gax::Grpc.create_stub(
          'service', 'port', channel: channel,
                             updater_proc: updater_proc, &blk
        )
      end.to raise_error(ArgumentError)

      expect do |blk|
        Google::Gax::Grpc.create_stub(
          'service', 'port', chan_creds: chan_creds,
                             updater_proc: updater_proc, &blk
        )
      end.to raise_error(ArgumentError)

      expect do |blk|
        Google::Gax::Grpc.create_stub(
          'service', 'port', channel: channel, chan_creds: chan_creds,
                             updater_proc: updater_proc, &blk
        )
      end.to raise_error(ArgumentError)
    end
  end
end
