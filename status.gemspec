$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "status/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "status"
  s.version     = Status::VERSION
  s.authors     = ["Patrik Stenmark"]
  s.email       = ["patrik@stenmark.io"]
  s.homepage    = "http://www.github.com/TV4/status"
  s.summary     = "Easy, customizable status pages"
  s.description = "A gem for Rack apps giving your app a /__status page which returns information about the app in JSON format"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
