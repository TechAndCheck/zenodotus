require "byebug"
require "typhoeus"
module MockDataIngestion
  class URLNotMockedError < StandardError; end

  # Load mock data JSON files and combine their data into a single hash to be included in test_helper.rb
  def self.ingest_mock_data
    mock_data_directory = File.join(File.dirname(__FILE__), "mock_data")
    mock_data_filenames = Dir.children(mock_data_directory)
    mock_data_hashes = parse_mock_files(mock_data_filenames, mock_data_directory)

    mock_data_hashes.reduce(:merge) # combine the hashes
  end

  # Load/parse each file in the mock_data directory. Return the parsed hashes
  def self.parse_mock_files(mock_data_filenames, mock_data_directory)
    mock_data_filenames.map do |fn|
      file_path = "#{mock_data_directory}/#{fn}"
      file_text = File.open(file_path).read

      JSON.parse(file_text)
    end
  end

  MOCK_DATA = ingest_mock_data

  Typhoeus.stub(ENV["HYPATIA_URL"]) do |request|
    media_url = request.options[:params][:url]

    # Tests should never hit live Hypatia. Raise an error if a test makes a request to a URL we haven't mocked out.
    unless MOCK_DATA.has_key?(media_url)
      raise URLNotMockedError, "The URL you're using in a test, #{media_url}, was not caught by the Typhoeus mock. Please use a mocked URL or update the mock with this URL."
    end

    # Stringify response body and scrape_result attribute
    mock_body = MOCK_DATA[media_url]
    mock_body["scrape_result"] = JSON.dump(mock_body["scrape_result"])
    mock_body = JSON.dump(mock_body)

    Typhoeus::Response.new(body: mock_body, code: 200) # Return the appropriate mocked responses
  end
end
