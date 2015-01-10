require "logeater/parser"
require "logeater/reader"
require "logeater/request"
require "logeater/version"
require "standalone_migrations"

configurator = StandaloneMigrations::Configurator.new
ActiveRecord::Base.establish_connection configurator.config_for(Rails.env)

module Logeater
end
