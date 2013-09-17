$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "first_click_free/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "first_click_free"
  s.version     = FirstClickFree::VERSION
  s.authors     = ["Josh McArthur"]
  s.email       = ["joshua.mcarthur@gmail.com"]
  s.homepage    = "https://github.com/joshmcarthur/first_click_free"
  s.summary     = "Automatically support first-click-free access to your content."
  s.description = "Automatically allow Google-crawling and new visitors to your application
                   access to content without requiring sign-in."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.1"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
