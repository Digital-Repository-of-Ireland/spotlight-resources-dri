$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spotlight/resources/dri/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spotlight-resources-dri"
  s.version     = Spotlight::Resources::Dri::VERSION
  s.authors     = ["Stuart Kenny"]
  s.email       = ["stuart.kenny@tchpc.tcd.ie"]
  s.summary     = "Ingest of DRI objects into Spotlight"
  s.license     = "Apache-2.0"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE.md", "Rakefile", "README.md"]

  s.add_dependency "blacklight-spotlight"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rails"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner', '~> 1.3'
  s.add_development_dependency "coveralls"
  s.add_development_dependency 'rubocop'
  s.add_development_dependency "rubocop-rspec"
  s.add_development_dependency "yard"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "solr_wrapper"
  s.add_development_dependency "riiif", '~> 1.0'
  s.add_development_dependency "i18n", "< 1.1.0"
end
