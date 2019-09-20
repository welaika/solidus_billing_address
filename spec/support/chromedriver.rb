# frozen_string_literal: true

require 'webdrivers'
require 'selenium-webdriver'

Capybara.server = :webrick

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.headless!
  options.add_argument '--window-size=1680,1050'

  if ENV['CI'].present?
    # NOTE: alternative, create a chrome user
    #       https://github.com/GoogleChromeLabs/lighthousebot/blob/master/builder/Dockerfile#L35-L40
    options.add_argument '--no-sandbox'

    options.add_argument '--disable-gpu'
    options.add_argument '--disable-dev-shm-usage'
  end

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = ENV.fetch('DRIVER', 'headless_chrome').to_sym
Capybara.default_max_wait_time = 4

RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :feature) do
    config.before :suite do
      # Preload assets
      if Rails.application.respond_to?(:precompiled_assets)
        Rails.application.precompiled_assets
      else
        # For older sprockets 2.x
        Rails.application.config.assets.precompile.each do |asset|
          Rails.application.assets.find_asset(asset)
        end
      end
    end
  end
end
