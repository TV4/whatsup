$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "status/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "status"
  s.version     = Status::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Status."
  s.description = "TODO: Description of Status."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "attr_extras", "~> 3.0.0"

  s.add_development_dependency "sqlite3"
end
