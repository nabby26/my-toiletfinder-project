# Copyright 2016 Google Inc. All rights reserved.
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

##
# This file is here to be autorequired by bundler, so that the .trace and
# #trace methods can be available, but the library and all dependencies won't
# be loaded until required and used.


gem "google-cloud-core"
require "google/cloud"

module Google
  module Cloud
    ##
    # Creates a new object for connecting to the Stackdriver Trace service.
    # Each call creates a new connection.
    #
    # For more information on connecting to Google Cloud see the [Authentication
    # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/guides/authentication).
    #
    # @param [String, Array<String>] scope The OAuth 2.0 scopes controlling the
    #   set of resources and operations that the connection can access. See
    #   [Using OAuth 2.0 to Access Google
    #   APIs](https://developers.google.com/identity/protocols/OAuth2).
    #   The default scope is `https://www.googleapis.com/auth/cloud-platform`
    # @param [Integer] timeout Default timeout to use in requests. Optional.
    #
    # @return [Google::Cloud::Trace::Project]
    #
    # @example
    #   require "google/cloud"
    #
    #   gcloud = Google::Cloud.new
    #   trace_client = gcloud.trace
    #
    #   traces = trace_client.list_traces Time.now - 3600, Time.now
    #   traces.each do |trace|
    #     puts "Retrieved trace ID: #{trace.trace_id}"
    #   end
    #
    def trace scope: nil, timeout: nil, client_config: nil
      Google::Cloud.trace @project, @keyfile, scope: scope,
                                              timeout: (timeout || @timeout),
                                              client_config: client_config
    end

    ##
    # Creates a new object for connecting to the Stackdriver Trace service.
    # Each call creates a new connection.
    #
    # For more information on connecting to Google Cloud see the [Authentication
    # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/guides/authentication).
    #
    # @param [String] project Project identifier for the Stackdriver Trace
    #   service.
    # @param [String, Hash] keyfile Keyfile downloaded from Google Cloud:
    #   either the JSON data or the path to a readable file.
    # @param [String, Array<String>] scope The OAuth 2.0 scopes controlling the
    #   set of resources and operations that the connection can access. See
    #   [Using OAuth 2.0 to Access Google
    #   APIs](https://developers.google.com/identity/protocols/OAuth2).
    #   The default scope is `https://www.googleapis.com/auth/cloud-platform`
    # @param [Integer] timeout Default timeout to use in requests. Optional.
    #
    # @return [Google::Cloud::Trace::Project]
    #
    # @example
    #   require "google/cloud"
    #
    #   trace_client = Google::Cloud.trace
    #
    #   traces = trace_client.list_traces Time.now - 3600, Time.now
    #   traces.each do |trace|
    #     puts "Retrieved trace ID: #{trace.trace_id}"
    #   end
    #
    def self.trace project = nil, keyfile = nil, scope: nil, timeout: nil,
                   client_config: nil
      require "google/cloud/trace"
      Google::Cloud::Trace.new project: project, keyfile: keyfile,
                               scope: scope, timeout: timeout,
                               client_config: client_config
    end
  end
end
