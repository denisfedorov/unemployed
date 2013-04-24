require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end

Capybara.javascript_driver = :poltergeist