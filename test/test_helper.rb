ENV["RAILS_ENV"] = "test"
require "rubygems"
require "rails"
require "rails/test_help"
require "pry"
require "database_cleaner"
require "shoulda/context"
require "turn"
require "logeater"

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
