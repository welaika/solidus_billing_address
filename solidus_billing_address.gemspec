# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_billing_address/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_billing_address'
  s.version     = SolidusBillingAddress::VERSION
  s.summary     = 'Solidus extension for (italian) billing address requirements'
  s.description = 'Modifies Spree::Address to allow customer to enter VAT Number, codice fiscale (personal tax code), PEC email and SDI code (codice fatturazione elettronica)'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Fabrizio Monti'
  s.email     = 'fabrizio.monti@welaika.com'
  s.homepage  = 'https://dev.welaika.com'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'solidus_core', '~> 2.8', '>= 2.8.2'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'gem-release'
end
