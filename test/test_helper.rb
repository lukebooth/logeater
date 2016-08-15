ENV["RAILS_ENV"] = "test"
require "rubygems"
require "active_support/testing/autorun"
require "active_support/test_case"
require "pry"
require "database_cleaner"
require "shoulda/context"
require "logeater"

require "minitest/reporters"
require "minitest/reporters/turn_reporter"
Minitest::Reporters.use! [Minitest::Reporters::TurnReporter.new]

load File.expand_path("../../db/schema.rb", __FILE__)

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

end
