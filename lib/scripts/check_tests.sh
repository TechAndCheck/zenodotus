#!/usr/bin/env ruby

# Get all the test files
files = Dir.glob('test/**/*_test.rb')

# Run each test file
files.each do |file|
  puts "Running #{file}"
  system("rails test #{file}")

  # Check if the test failed
  if $?.exitstatus != 0
    puts "Test failed: #{file}"
    exit 1
  end
end
