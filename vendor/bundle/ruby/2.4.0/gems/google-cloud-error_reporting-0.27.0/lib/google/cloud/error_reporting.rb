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


require "google-cloud-error_reporting"
require "google/cloud/error_reporting/async_error_reporter"
require "google/cloud/error_reporting/project"
require "google/cloud/error_reporting/middleware"
require "stackdriver/core"

module Google
  module Cloud
    ##
    # # ErrorReporting
    #
    # Stackdriver Error Reporting counts, analyzes and aggregates the crashes in
    # your running cloud services. The Stackdriver Error Reporting
    # Instrumentation client provides
    # [a simple way to report errors](#how-to-report-errors) from your
    # application.
    #
    # For general information about Stackdriver Error Reporting, read
    # [Stackdriver Error Reporting
    # Documentation](https://cloud.google.com/error-reporting/docs/).
    #
    # The goal of google-cloud-ruby is to provide an API that is comfortable to
    # Rubyists. Authentication is handled by the client. You can provide the
    # project and credential information to connect to the Stackdriver Error
    # Reporting service, or if you are running on Google Cloud Platform this
    # configuration is taken care of for you. You can read more about the
    # options for connecting in the [Authentication
    # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/guides/authentication).
    #
    # ## How to report errors
    #
    # You can easily report exceptions from your applications to Stackdriver
    # Error Reporting service:
    #
    # ```ruby
    # require "google/cloud/error_reporting"
    #
    # # Configure Stackdriver ErrorReporting instrumentation
    # Google::Cloud::ErrorReporting.configure do |config|
    #   config.project_id = "my-project"
    #   config.keyfile = "/path/to/keyfile.json"
    # end
    #
    # # Insert a Rack Middleware to report unhanded exceptions
    # use Google::Cloud::ErrorReporting::Middleware
    #
    # # Or explicitly submit exceptions
    # begin
    #   fail "Boom!"
    # rescue => exception
    #   Google::Cloud::ErrorReporting.report exception
    # end
    # ```
    #
    # See the [Instrumentation
    # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-error_reporting/guides/instrumentation)
    # for more examples.
    #
    module ErrorReporting
      # Initialize :error_reporting as a nested Configuration under
      # Google::Cloud if haven't already
      unless Google::Cloud.configure.option? :error_reporting
        Google::Cloud.configure.add_options :error_reporting
      end

      ##
      # @private The default Google::Cloud::ErrorReporting::Project client used
      # for the Google::Cloud::ErrorReporting.report API.
      @@default_client = nil

      ##
      # Creates a new object for connecting to the Stackdriver Error Reporting
      # service. Each call creates a new connection.
      #
      # For more information on connecting to Google Cloud see the
      # [Authentication
      # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/guides/authentication).
      #
      # @param [String] project Project identifier for the Stackdriver Error
      #   Reporting service.
      # @param [String, Hash] keyfile Keyfile downloaded from Google Cloud. If
      #   file path the file must be readable.
      # @param [String, Array<String>] scope The OAuth 2.0 scopes controlling
      #   the set of resources and operations that the connection can access.
      #   See [Using OAuth 2.0 to Access Google
      #   APIs](https://developers.google.com/identity/protocols/OAuth2).
      #
      #   The default scope is:
      #
      #   * `https://www.googleapis.com/auth/cloud-platform`
      #
      # @param [Integer] timeout Default timeout to use in requests. Optional.
      # @param [Hash] client_config A hash of values to override the default
      #   behavior of the API client. Optional.
      #
      # @return [Google::Cloud::ErrorReporting::Project]
      #
      # @example
      #   require "google/cloud/error_reporting"
      #
      #   error_reporting = Google::Cloud::ErrorReporting.new
      #   # ...
      #
      def self.new project: nil, keyfile: nil, scope: nil, timeout: nil,
                   client_config: nil
        project ||= Google::Cloud::ErrorReporting::Project.default_project
        project = project.to_s
        fail ArgumentError, "project is missing" if project.empty?

        credentials =
          Google::Cloud::ErrorReporting::Credentials.credentials_with_scope(
            keyfile, scope)

        Google::Cloud::ErrorReporting::Project.new(
          Google::Cloud::ErrorReporting::Service.new(
            project, credentials, timeout: timeout, client_config: client_config
          )
        )
      end

      ##
      # Configure the default {Google::Cloud::ErrorReporting::Project}
      # client, allows the {.report} public method to reuse these
      # configured parameters.
      #
      # See the [Configuration
      # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/stackdriver/guides/instrumentation_configuration)
      # for full configuration parameters.
      #
      # @example
      #   # in app.rb
      #   require "google/cloud/error_reporting"
      #
      #   Google::Cloud::ErrorReporting.configure do |config|
      #     config.project_id = "my-project-id"
      #     config.keyfile = "/path/to/keyfile.json"
      #     config.service_name = "my-service"
      #     config.service_version = "v8"
      #   end
      #
      #   begin
      #     fail "boom"
      #   rescue => exception
      #     # Report exception using configuration parameters provided above
      #     Google::Cloud::ErrorReporting.report exception
      #   end
      #
      # @return [Stackdriver::Core::Configuration] The configuration object
      #   the Google::Cloud::ErrorReporting module uses.
      #
      def self.configure
        yield Google::Cloud.configure.error_reporting if block_given?

        Google::Cloud.configure.error_reporting
      end

      ##
      # Provides an easy-to-use interface to Report a Ruby exception object to
      # Stackdriver ErrorReporting service. This method helps users to
      # transform the Ruby exception into an Stackdriver ErrorReporting
      # ErrorEvent gRPC structure, so users don't need to. This should be the
      # prefered method to use when users wish to report captured exception in
      # applications.
      #
      # This public method creates a default Stackdriver ErrorReporting client
      # and reuse that between calls. The default client is initialized with
      # parameters defined in {.configure}.
      #
      # The error event can be customized before reporting. See the example
      # below and {Google::Cloud::ErrorReporting::ErrorEvent} class for avaiable
      # error event fields.
      #
      # @example Basic usage
      #   # in app.rb
      #   require "google/cloud/error_reporting"
      #
      #   begin
      #     fail "boom"
      #   rescue => exception
      #     # Report exception using configuration parameters provided above
      #     Google::Cloud::ErrorReporting.report exception
      #   end
      #
      # @example The error event can be customized if needed
      #   require "google/cloud/error_reporting"
      #
      #   begin
      #     fail "boom"
      #   rescue => exception
      #     Google::Cloud::ErrorReporting.report exception do |error_event|
      #       error_event.user = "johndoh@example.com"
      #       error_event.http_status = "502"
      #     end
      #   end
      #
      # @param [Exception] exception The captured Ruby Exception object
      # @param [String] service_name An identifier for running service.
      #   Optional.
      # @param [String] service_version A version identifier for running
      #   service.
      #
      def self.report exception, service_name: nil, service_version: nil
        return if Google::Cloud.configure.use_error_reporting == false

        service_name ||= configure.service_name ||
                         Project.default_service_name
        service_version ||= configure.service_version ||
                            Project.default_service_version

        error_event = ErrorEvent.from_exception(exception).tap do |event|
          event.service_name = service_name
          event.service_version = service_version
        end

        yield error_event if block_given?

        default_client.report error_event
      end

      ##
      # @private Create a private client to
      def self.default_client
        unless @@default_client
          project_id = configure.project_id ||
                       Google::Cloud.configure.project_id
          keyfile = configure.keyfile ||
                    Google::Cloud.configure.keyfile

          @@default_client = AsyncErrorReporter.new(
            new(project: project_id, keyfile: keyfile)
          )
        end

        @@default_client
      end

      private_class_method :default_client
    end
  end
end
