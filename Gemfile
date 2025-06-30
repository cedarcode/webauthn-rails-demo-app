# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', "~> 8.0.1"
gem "webauthn", "~> 3.4"

gem 'bootsnap', '~> 1.18', require: false
gem 'importmap-rails', '~> 2.1'
gem 'puma', '~> 6.6'
gem "rollbar", "~> 3.6"
gem 'sassc-rails', '~> 2.0'
gem 'sqlite3', '>= 1.4'
gem 'stimulus-rails', '~> 1.3'

group :development, :deploy do
  gem "kamal", '~> 2.7'
end

group :development, :test do
  gem 'byebug', '~> 12.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop', '~> 1.77', require: false
  gem 'rubocop-rails', '~> 2.32', require: false
end

group :development do
  gem "brakeman", '~> 7.0'
  gem "bundler-audit", '~> 0.9.1'
  gem "rack-mini-profiler", "~> 4.0"
  gem 'web-console', '~> 4.2', '>= 4.2.1'
end

group :test do
  gem 'capybara', '~> 3.26'
  gem 'minitest-stub_any_instance', '~> 1.0'
  gem 'selenium-webdriver', '~> 4.34'
end
