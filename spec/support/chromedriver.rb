# frozen_string_literal: true

require 'webdrivers' if ENV['TRAVIS'].present?

Capybara.server = :webrick

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = if ENV['TRAVIS'].present?
                   Selenium::WebDriver::Remote::Capabilities.chrome(
                     chromeOptions: { args: %w[no-sandbox headless disable-gpu] }
                   )
                 else
                   Selenium::WebDriver::Remote::Capabilities.chrome(
                     chromeOptions: { args: %w[headless disable-gpu] }
                   )
                 end

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 3

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
