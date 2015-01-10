require "bundler/gem_tasks"

require "standalone_migrations"
StandaloneMigrations::Tasks.load_tasks

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end
