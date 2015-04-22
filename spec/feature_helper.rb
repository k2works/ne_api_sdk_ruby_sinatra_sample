require 'spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.default_driver = :selenium
RSpec.configure do |config|
  config.include Capybara::DSL
end