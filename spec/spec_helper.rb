require 'rspec'
require 'rspec/expectations'
require 'capybara/rspec'
require 'capybara/dsl'

require 'parallel'
require 'selenium/webdriver'

# Capybara Configuration
Capybara.default_wait_time = 90
Capybara.default_selector = :css

# Rspec Configuration
RSpec.configure do |config|
  config.filter_run_excluding :broken => true

  config.before(:all) do
    # TBD
  end

  config.after(:all) do
    Capybara.reset!
  end

end

Capybara.register_driver :browserstack do |app|
  require_relative 'extensions/fast-selenium'

  url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
  capabilities = Selenium::WebDriver::Remote::Capabilities.new

  if ENV['BS_AUTOMATE_OS']
    capabilities['os'] = ENV['BS_AUTOMATE_OS']
    capabilities['os_version'] = ENV['BS_AUTOMATE_OS_VERSION']
  else
    capabilities['platform'] = ENV['SELENIUM_PLATFORM'] || 'ANY'
  end

  capabilities['resolution'] = '1280x1024'
  capabilities['browser'] = ENV['SELENIUM_BROWSER'] || 'chrome'
  capabilities['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']
  capabilities['browserstack.debug'] = 'true'
  capabilities['browserstack.local'] = 'false'
  capabilities['project'] = ENV['BS_AUTOMATE_PROJECT'] if ENV['BS_AUTOMATE_PROJECT']
  capabilities['build'] = ENV['BS_AUTOMATE_BUILD'] if ENV['BS_AUTOMATE_BUILD']

  Capybara::Selenium::Driver.new(app,
                                 :browser => :remote,
                                 :url => url,
                                 :desired_capabilities => capabilities)
end

Capybara.register_driver :saucelabs do |app|

# Use Capybara integration
#   require "sauce"
#   require "sauce/capybara"
#
#   # require 'capybara/rails'
#   require 'capybara/rspec'

  # capabilities = Selenium::WebDriver::Remote::Capabilities.new
  # capabilities['name'] = 'capybara-rspec'
  # capabilities['platform'] = 'OS X 10.10'
  # capabilities['version'] = '41.0'

  # Capybara.default_driver = :sauce
  # Capybara.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i

  # Capybara::Selenium::Driver.new(app,
  #                                # :browser => :remote,
  #                                :desired_capabilities => capabilities)

  # Approach TWO
  # Use Capybara integration
  require "sauce"
  require "sauce/capybara"
  # require "capybara/rails"
  require "capybara/rspec"

# Set up configuration
  Sauce.config do |c|
    c[:browsers] = [
        ["Windows 8", "Internet Explorer", "10"],
        ["Windows 7", "Firefox", "20"],
        ["OS X 10.10", "Safari", "8"],
        ["Linux", "Chrome", 40]
    ]
    # config[:sauce_connect_4_executable] = '/some/file/path/sc-4.3.8-osx/bin/sc'
  end

  Capybara.default_driver = :sauce
  Capybara.javascript_driver = :sauce
end

Capybara.register_driver :poltergeist do |app|
  require 'capybara/poltergeist'

  Capybara::Poltergeist::Driver.new(app,
                                    js_errors: false,
                                    window_size: [1280, 1024])
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

if ENV['HEADLESS']
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
elsif ENV['BSTACK']
  Capybara.default_driver = :browserstack
elsif ENV['SAUCE']
  Capybara.default_driver = :saucelabs
else
  Capybara.default_driver = :selenium
end

Capybara.run_server = false
Capybara.app_host = ENV['ACCEPTANCE_TEST_HOST'] || "http://easybtn-stage.usatoday.com"