# Copyright 2017 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require "google/cloud/errors"
require "google/cloud/debugger/version"
require "google/cloud/debugger/v2"
require "google/gax/errors"

module Google
  module Cloud
    module Debugger
      ##
      # @private Represents the gRPC Debugger service, including all the API
      # methods.
      class Service
        attr_accessor :project, :credentials, :host, :timeout, :client_config

        ##
        # Creates a new Service instance.
        def initialize project, credentials, host: nil, timeout: nil,
                       client_config: nil
          @project = project
          @credentials = credentials
          @host = host || V2::Controller2Client::SERVICE_ADDRESS
          @timeout = timeout
          @client_config = client_config || {}
        end

        def channel
          require "grpc"
          GRPC::Core::Channel.new host, nil, chan_creds
        end

        def chan_creds
          return credentials if insecure?
          require "grpc"
          GRPC::Core::ChannelCredentials.new.compose \
            GRPC::Core::CallCredentials.new credentials.client.updater_proc
        end

        def cloud_debugger
          return mocked_debugger if mocked_debugger
          @debugger ||=
            V2::Controller2Client.new(
              service_path: host,
              channel: channel,
              timeout: timeout,
              client_config: client_config,
              lib_name: "gccl",
              lib_version: Google::Cloud::Debugger::VERSION)
        end
        attr_accessor :mocked_debugger

        def transmitter
          return mocked_transmitter if mocked_transmitter
          @transmitter ||=
            V2::Controller2Client.new(
              service_path: host,
              channel: channel,
              timeout: timeout,
              client_config: client_config,
              lib_name: "gccl",
              lib_version: Google::Cloud::Debugger::VERSION)
        end
        attr_accessor :mocked_transmitter

        def insecure?
          credentials == :this_channel_is_insecure
        end

        def register_debuggee debuggee_grpc
          execute do
            cloud_debugger.register_debuggee debuggee_grpc,
                                             options: default_options
          end
        end

        def list_active_breakpoints debuggee_id, wait_token
          execute do
            cloud_debugger.list_active_breakpoints debuggee_id.to_s,
                                                   wait_token: wait_token.to_s,
                                                   success_on_timeout: true,
                                                   options: default_options
          end
        end

        def update_active_breakpoint debuggee_id, breakpoint
          execute do
            transmitter.update_active_breakpoint debuggee_id.to_s,
                                                 breakpoint.to_grpc,
                                                 options: default_options
          end
        end

        def inspect
          "#{self.class}(#{@project})"
        end

        protected

        def default_headers
          { "google-cloud-resource-prefix" => "projects/#{@project}" }
        end

        def default_options
          Google::Gax::CallOptions.new kwargs: default_headers
        end

        def execute
          yield
        rescue Google::Gax::GaxError => e
          # GaxError wraps BadStatus, but exposes it as #cause
          raise Google::Cloud::Error.from_error(e.cause)
        end
      end
    end
  end
end
