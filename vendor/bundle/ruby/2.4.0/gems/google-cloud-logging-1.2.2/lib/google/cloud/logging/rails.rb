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

require "google/cloud/logging"

module Google
  module Cloud
    module Logging
      ##
      # Default log name to be used for Stackdriver Logging
      DEFAULT_LOG_NAME = Middleware::DEFAULT_LOG_NAME

      ##
      # Railtie
      #
      # Adds the {Google::Cloud::Logging::Middleware} to Rack in a Rails
      # environment. The middleware will set `env['rack.logger']` to a
      # {Google::Cloud::Logging::Logger} instance to be used by the Rails
      # application.
      #
      # The Middleware is only added when certain conditions are met. See
      # {use_logging?} for details.
      #
      # When loaded, the {Google::Cloud::Logging::Middleware} will be inserted
      # before the `Rails::Rack::Logger Middleware`, which allows it to set the
      # `env['rack.logger']` in place of Rails's default logger.
      # See the [Configuration
      # Guide](https://googlecloudplatform.github.io/google-cloud-ruby/#/docs/stackdriver/guides/instrumentation_configuration)
      # on how to configure the Railtie and Middleware.
      #
      class Railtie < ::Rails::Railtie
        config.google_cloud = ::ActiveSupport::OrderedOptions.new unless
          config.respond_to? :google_cloud
        config.google_cloud.logging = ::ActiveSupport::OrderedOptions.new
        config.google_cloud.logging.monitored_resource =
          ::ActiveSupport::OrderedOptions.new
        config.google_cloud.logging.monitored_resource.labels =
          ::ActiveSupport::OrderedOptions.new

        initializer "Stackdriver.Logging", before: :initialize_logger do |app|
          self.class.consolidate_rails_config app.config

          self.class.init_middleware app if Cloud.configure.use_logging
        end

        ##
        # @private Init Logging integration for Rails. Setup configuration and
        # insert the Middleware.
        def self.init_middleware app
          project_id = Logging.configure.project_id
          keyfile = Logging.configure.keyfile
          resource_type = Logging.configure.monitored_resource.type
          resource_labels = Logging.configure.monitored_resource.labels
          log_name = Logging.configure.log_name
          labels = Logging.configure.labels

          logging = Google::Cloud::Logging.new project: project_id,
                                               keyfile: keyfile
          resource =
            Logging::Middleware.build_monitored_resource resource_type,
                                                         resource_labels

          app.config.logger = logging.logger log_name, resource, labels
          app.middleware.insert_before Rails::Rack::Logger,
                                       Google::Cloud::Logging::Middleware,
                                       logger: app.config.logger
        end

        ##
        # @private Consolidate Rails configuration into Logging instrumentation
        # configuration. Also consolidate the `use_logging` setting by verifying
        # credentials and Rails environment. The `use_logging` setting will be
        # true if credentials are valid, and the setting is manually set to true
        # or Rails is in production environment.
        #
        # @param [Rails::Railtie::Configuration] config The
        #   Rails.application.config
        #
        def self.consolidate_rails_config config
          merge_rails_config config

          init_default_config

          # Done if Google::Cloud.configure.use_logging is explicitly false
          return if Google::Cloud.configure.use_logging == false

          # Verify credentials and set use_error_reporting to false if
          # credentials are invalid
          unless valid_credentials? Logging.configure.project_id,
                                    Logging.configure.keyfile
            Cloud.configure.use_logging = false
            return
          end

          # Otherwise set use_logging to true if Rails is running in production
          Google::Cloud.configure.use_logging ||= Rails.env.production?
        end

        ##
        # @private Merge Rails configuration into Logging instrumentation
        # configuration.
        def self.merge_rails_config rails_config # rubocop:disable AbcSize
          gcp_config = rails_config.google_cloud
          logging_config = gcp_config.logging

          Cloud.configure.use_logging ||= gcp_config.use_logging
          Logging.configure do |config|
            config.project_id ||= logging_config.project_id ||
                                  gcp_config.project_id
            config.keyfile ||= logging_config.keyfile || gcp_config.keyfile
            config.log_name ||= logging_config.log_name
            config.labels ||= logging_config.labels
            config.log_name_map ||= logging_config.log_name_map
            config.monitored_resource.type ||=
              logging_config.monitored_resource.type
            config.monitored_resource.labels ||=
              logging_config.monitored_resource.labels.to_h
          end
        end

        ##
        # Fallback to default config values if config parameters not provided.
        def self.init_default_config
          Logging.configure.project_id ||= Logging::Project.default_project
          Logging.configure.log_name ||= Middleware::DEFAULT_LOG_NAME
        end

        ##
        # @private Verify credentials
        def self.valid_credentials? project_id, keyfile
          # Try authenticate authorize client API. Return false if unable to
          # authorize.
          begin
            Google::Cloud::Logging::Credentials.credentials_with_scope keyfile
          rescue Exception => e
            STDOUT.puts "Note: Google::Cloud::Logging is disabled because " \
              "it failed to authorize with the service. (#{e.message}) " \
              "Falling back to the default Rails logger."
            return false
          end

          if project_id.to_s.empty?
            STDOUT.puts "Note: Google::Cloud::Logging is disabled because " \
              "the project ID could not be determined. " \
              "Falling back to the default Rails logger."
            return false
          end

          true
        end

        private_class_method :merge_rails_config,
                             :init_default_config,
                             :valid_credentials?
      end
    end
  end
end
