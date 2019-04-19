# frozen_string_literal: true

Capybara.server = :webrick

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu start-maximized] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :chrome
Capybara.default_max_wait_time = 5

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

  config.before(:each, type: :system) do
    if ENV['SELENIUM_REMOTE_URL'].present?
      # Make the test app listen to outside requests, for the remote Selenium instance.
      Capybara.server_host = '0.0.0.0'

      # Specify the driver
      driven_by :selenium, using: :chrome, screen_size: [1400, 2000],
                           options: { url: ENV['SELENIUM_REMOTE_URL'] }

      # Get the rails application IP
      rails_ip = Socket.ip_address_list.find(&:ipv4_private?).ip_address

      # Set the rails application Port (choose what you want)
      Capybara.server_port = 3001

      # Use the IP instead of localhost so Capybara knows where to direct Selenium
      host! "http://#{rails_ip}:#{Capybara.server_port}"
    else
      # Otherwise, use the local machine's chromedriver
      driven_by :headless_chrome
    end
  end
end
