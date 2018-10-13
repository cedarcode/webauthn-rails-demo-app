# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem "webauthn", "~> 1.3"

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sassc-rails', '~> 1.3'
# gem 'uglifier', '>= 1.3.0'

gem 'turbolinks', '~> 5'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'webpacker', '~> 3.5'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
  gem 'rubocop', '~> 0.59.2', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

gem "rollbar", "~> 2.16"
gem "useragent", "~> 0.16.10"
