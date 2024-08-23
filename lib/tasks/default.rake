# frozen_string_literal: true

if Rails.env.local?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:rubocop, :test]
end
