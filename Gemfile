# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', "~> 8.1.1"
gem "webauthn", "~> 3.4"

gem 'bootsnap', '~> 1.19', require: false
gem 'importmap-rails', '~> 2.2'
gem 'propshaft', '~> 1.3'
gem 'puma', '~> 7.1'
gem "rollbar", "~> 3.7"
gem 'sqlite3', '>= 1.4'
gem 'stimulus-rails', '~> 1.3'

group :development, :deploy do
  gem "kamal", '~> 2.9'
end

group :development, :test do
  gem 'byebug', '~> 12.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', '~> 1.81', require: false
  gem 'rubocop-rails', '~> 2.34', require: false
end

group :development do
  gem "brakeman", '~> 7.1'
  gem "bundler-audit", '~> 0.9.3'
  gem "rack-mini-profiler", "~> 4.0"
  gem 'web-console', '~> 4.2', '>= 4.2.1'
end

group :test do
  gem 'capybara', '~> 3.26'
  gem 'minitest-stub_any_instance', '~> 1.0'
  gem 'selenium-webdriver', '~> 4.38'
end
