# Require this file for unit tests
ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rspec/hanami'
require 'vcr'
require 'webmock/rspec'
require 'fabrication'

Hanami.boot
Hanami::Utils.require!("#{__dir__}/support")

RSpec.configure do |config|
  config.include RSpec::Hanami::Matchers
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
