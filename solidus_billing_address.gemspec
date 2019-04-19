# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'solidus_billing_address/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_billing_address'
  s.version     = SolidusBillingAddress::VERSION
  s.summary     = 'Solidus extension for (italian) billing address requirements'
  s.description = 'Modifies Spree::Address to allow customer to enter VAT Number,' \
                  ' codice fiscale (personal tax code), PEC email and SDI code' \
                  ' (codice fatturazione elettronica)'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Fabrizio Monti'
  s.email     = 'fabrizio.monti@welaika.com'
  s.homepage  = 'https://dev.welaika.com'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'solidus_core', '~> 2.8', '>= 2.8.2'

  s.add_development_dependency 'capybara', '~> 3.17'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.7'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'gem-release'
  s.add_development_dependency 'pry-byebug', '~> 3.7'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.67.2'
  s.add_development_dependency 'rubocop-performance', '~> 1.1'
  s.add_development_dependency 'rubocop-rspec', '~> 1.32'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver', '~> 3.141'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'site_prism', '~> 3.1'
  s.add_development_dependency 'sqlite3'
end
