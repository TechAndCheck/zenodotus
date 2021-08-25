# frozen_string_literal: true

# typed: ignore
require "test_helper"
require "generators/media_source/media_source_generator"

class MediaSourceGeneratorTest < Rails::Generators::TestCase
  tests MediaSourceGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
