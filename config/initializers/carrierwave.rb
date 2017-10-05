CarrierWave.configure do |config|
    config.fog_provider = 'fog/google'                        # required
    config.fog_credentials = {
      provider:                         'Google',
      google_storage_access_key_id:     'GOOGKAXF4Y7EKQ62P7LS',
      google_storage_secret_access_key: 'a7ZssG9XdLbMWKIXdGxdEuM/e1yWtphO1ie3zrep'
    }
    config.fog_directory = 'my-toiletfinder-project.appspot.com'
  end