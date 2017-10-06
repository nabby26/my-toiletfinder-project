# Copyright 2014 Google Inc. All rights reserved.
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


require "google/cloud/credentials"

module Google
  module Cloud
    module Datastore
      ##
      # @private
      #
      # Authentication credentials to Google Cloud.
      # The most common way to create this object is to provide the path
      # to the JSON keyfile downloaded from Google Cloud.
      #
      # @see https://developers.google.com/accounts/docs/application-default-credentials
      class Credentials < Google::Cloud::Credentials
        SCOPE = ["https://www.googleapis.com/auth/datastore"]
        PATH_ENV_VARS = %w(DATASTORE_KEYFILE GOOGLE_CLOUD_KEYFILE
                           GCLOUD_KEYFILE)
        JSON_ENV_VARS = %w(DATASTORE_KEYFILE_JSON GOOGLE_CLOUD_KEYFILE_JSON
                           GCLOUD_KEYFILE_JSON)
      end
    end
  end
end
