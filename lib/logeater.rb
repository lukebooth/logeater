require "logeater/parser"
require "logeater/reader"
require "logeater/request"
require "logeater/version"
require "yaml"
require "erb"

config_file = File.expand_path("../../db/config.yml", __FILE__)
config = YAML.load(ERB.new(File.read(config_file)).result).with_indifferent_access
ActiveRecord::Base.establish_connection config[ENV["RAILS_ENV"] || "development"]

module Logeater
end
