# typed: false
require "simplecov"
require "minitest/autorun"
require_relative "hypatia_mock"

include HypatiaMock 

SimpleCov.start "rails" do
  enable_coverage :branch
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

BIG_DOG = 0

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module Minitest::Assertions
  # Assert return is a Sorbet Void type
  def assert_void(obj)
    assert_equal(T::Private::Types::Void::VOID, obj)
  end
end
