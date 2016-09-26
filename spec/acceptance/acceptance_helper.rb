require 'rails_helper'
require 'capybara/poltergeist'
# require 'capybara/rspec'

RSpec.configure do |config|
  # Capybara.javascript_driver = :webkit
  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :selenium

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end

  config.include AcceptanceMacros, type: :feature  

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = false
end