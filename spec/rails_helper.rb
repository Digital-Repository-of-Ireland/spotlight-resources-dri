ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'

require 'engine_cart'
EngineCart.load_application!

require 'factory_bot_rails'

require 'rspec/rails'
require 'database_cleaner'

# Require all support files
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction # non-js tests
    else
      DatabaseCleaner.strategy = :truncation # js tests
    end
    DatabaseCleaner.start

    # The first user is automatically granted admin privileges; we don't want that behavior for many of our tests
    User.create email: 'initial+admin@example.com', password: 'password', password_confirmation: 'password'
  end

  config.after { DatabaseCleaner.clean }
  config.include Warden::Test::Helpers, type: :feature # use login_as helper

  if Rails::VERSION::MAJOR >= 5
    config.include ::Rails.application.routes.url_helpers
    config.include ::Rails.application.routes.mounted_helpers
  else
    config.include BackportTestHelpers, type: :controller
  end
end
