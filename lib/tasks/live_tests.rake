# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new do |t|
  t.name = "test:live"
  t.description = "Run all live tests (requires human interaction)"
  t.libs << "test"
  t.pattern = "test/live/*_test.rb"
  t.verbose = true
  t.warning = false
end

Rake::Task["test"].clear
Rake::TestTask.new do |t|
  t.name = "test"
  t.description = "Run all tests except system and live ones"
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
                 .exclude("test/system/*")
                 .exclude("test/live/*")
  t.verbose = true
  t.warning = false
end
