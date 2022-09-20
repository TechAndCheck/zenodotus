# typed: false

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
require "minitest/autorun"
require_relative "../config/environment"
require_relative "mocks/hypatia_mock"
require_relative "mocks/aws_s3_mock"

include HypatiaMock
include AwsS3Mock

SimpleCov.start "rails" do
  enable_coverage :branch
end

require "rails/test_help"

S3_MOCK_STUB = Proc.new do |url|
  AwsS3Mock::S3Mock.download_file_in_s3_received_from_hypatia(url)
end

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
