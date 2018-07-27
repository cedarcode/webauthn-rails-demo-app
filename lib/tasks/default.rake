# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:rubocop, :test]
end
