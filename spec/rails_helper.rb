ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!


module HandleExceptionsInSpecs
  def process(*)
    super
  rescue ActiveRecord::RecordNotFound
    @response.status = 404
  rescue ActionController::UnknownFormat
    @response.status = 406
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.include(HandleExceptionsInSpecs, type: :controller)
end
