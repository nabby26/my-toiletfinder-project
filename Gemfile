source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
gem 'bcrypt', platforms: :ruby
# gem 'bcrypt',         '3.1.7'
gem 'bootstrap-sass', '3.3.7'
gem 'sqlite3'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'gmaps4rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rake'
gem 'wdm', '>= 0.1.0' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Fog
gem "fog-google"
gem "google-api-client"
gem "mime-types"

# Use Google cloud
gem 'google-cloud-datastore', require: 'google/cloud/datastore'

# Use Google Cloud Storage
gem 'google-cloud-storage'
#Use Big query
gem "google-cloud-bigquery", require: 'google/cloud/bigquery'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Added at 2017-09-21 01:06:11 +1000 by olddata:
gem "appengine", "~> 0.4.2"

# Add Carrierwave for Google Storage
gem 'carrierwave'

# add mini magick
gem "mini_magick"

gem "rails-controller-testing"
