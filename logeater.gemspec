# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "logeater/version"

Gem::Specification.new do |spec|
  spec.name          = "logeater"
  spec.version       = Logeater::VERSION
  spec.authors       = ["Bob Lail"]
  spec.email         = ["bob.lail@cph.org"]
  spec.summary       = %q{Parses log files and imports them into a database}
  spec.description   = %q{Parses log files and imports them into a database}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 3.2.21"
  spec.add_dependency "activesupport"
  spec.add_dependency "pg"
  spec.add_dependency "standalone_migrations"
  spec.add_dependency "addressable"
  spec.add_dependency "ruby-progressbar"
  spec.add_dependency "activerecord-import", "~> 0.3.1"
  spec.add_dependency "activerecord-postgres-json"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails", ">= 3.1.0", "< 5.0.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "turn"
  spec.add_development_dependency "database_cleaner"

end
