module HypatiaMock
  require "typhoeus"

  class URLNotMockedError < StandardError; end

  # Returns a hash mapping media URLs to mock Hypatia response bodies
  # Loads mock response bodies from the test/mock_data directory and combines them into a single hash
  #
  # @!scope module
  # @params None
  # @return a Hash mapping URLs to mock Hypatia response bodies
  def self.ingest_mock_data
    mock_data_directory = File.join(File.dirname(__FILE__), "mock_data")
    mock_data_filenames = Dir.children(mock_data_directory)
    mock_data_hashes = parse_mock_files(mock_data_filenames, mock_data_directory)

    mock_data_hashes.reduce(:merge) # combine the hashes
  end

  # Reads the contents of an array of files and returns parsed versions of them
  #
  # @!scope module
  # @params mock_data_filenames: an array of mock data filenames
  # @params mock_data_directory: the name of the directory mocked data files are stored in
  # @return An array of hashes, each containing data parsed from the mock data files
  def self.parse_mock_files(mock_data_filenames, mock_data_directory)
    mock_data_filenames.map do |fn|
      file_path = "#{mock_data_directory}/#{fn}"
      file_text = File.open(file_path).read

      JSON.parse(file_text)
    end
  end

  # Returns the mock response for the input media URL
  # The `scrape_result` field is stringified to imitate the form Hypatia returns responses in
  # We marshal/unmarshal loaded data to avoid mutating the mock_data hash
  #
  # @!scope module
  # @params mock_data [Hash] A hash mapping URLs to mocked response bodies
  # @params media_url [String] The media post URL to return a mock Hypatia response for
  # @return [Typhoeus::Response] A Typhoeus response with a body containing mocked data
  def self.generate_force_response(mock_data, media_url)
    mock_body = mock_data[media_url]
    mock_body = Marshal.load(Marshal.dump(mock_body))  # make a deep copy to avoid mutating the mock_data hash

    # Stringify response body and scrape_result attribute
    mock_body["scrape_result"] = JSON.dump(mock_body["scrape_result"])
    mock_body = JSON.dump(mock_body)

    Typhoeus::Response.new(body: mock_body, code: 200) # Return the appropriate mocked responses
  end

  # Returns a simple success response, imitating Hypatia's responsess to non-force scrape requests
  #
  # @!scope module
  # @return [Typhoeus::Response] A Typheous response containing a queue success message
  def self.generate_nonforce_response
    success_message = { success: true }
    Typhoeus::Response.new(body: JSON.dump(success_message), code: 200)
  end


  # Validates that the input media URL has been mocked and returns a hypatia response with mocked data
  #
  # @!scope module
  # @params request [Typhoeus::Request] An intercepted Typhoeus request to Hypatia
  # @params mock_data [Hash] A hash mapping URLs to mocked response bodies
  # @return [Typhoeus::Response] A Typhoeus response with mocked data
  # def self.load_force_response(request, mock_data)
  #   generate_mock_response_for_url(mock_data, media_url)
  # end

  # Raises an error if the mock_data hash doesn't contain data for the input URL
  # This error prevents us from hitting live Hypatia in tests
  #
  # @!scope module
  # @params mock_data [Hash] A hash mapping URLs to mocked response bodies
  # @params media_url [String] The media post URL to return a mock Hypatia response for
  # @return nil
  def self.ensure_media_url_is_mocked(mock_data, media_url)
    unless mock_data.has_key?(media_url)
      raise URLNotMockedError, "URL #{media_url}, was not caught by the Typhoeus testing mock. Please use an already mocked URL in your test or update the mock with this URL."
    end
  end

  # Stubs Typhoeus requests to Hypatia.
  #
  # @! scope module
  # @return nil
  def self.construct_typhoeus_hypatia_stub
    mock_data = ingest_mock_data

    Typhoeus.stub(ENV["HYPATIA_SERVER_URL"]) do |request|
      media_url = request.options[:params][:url]
      ensure_media_url_is_mocked(mock_data, media_url)

      should_force_request = request.options[:params][:force] == "true"
      should_force_request ? generate_force_response(mock_data, media_url) : generate_nonforce_response
    end
  end

  construct_typhoeus_hypatia_stub
end
