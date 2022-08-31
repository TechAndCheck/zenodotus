module HypatiaMock
  require "typhoeus"

  class URLNotMockedError < StandardError; end

  # Returns a hash mapping media URLs to mock Hypatia response bodies
  # Loads mock response bodies from the test/mocks/data directory and combines them into a single hash
  #
  # @!scope module
  # @return [Hash] a hash mapping URLs to mock Hypatia response bodies
  def self.ingest_mock_data
    mock_data_directory = File.join(File.dirname(__FILE__), "data")
    mock_data_filenames = Dir.children(mock_data_directory)
    mock_data_hashes = parse_mock_files(mock_data_filenames, mock_data_directory)

    mock_data_hashes.reduce(:merge) # combine the hashes loaded from each file
  end

  # Reads the contents of an array of files and returns JSON parsed versions of them
  #
  # @!scope module
  # @param mock_data_filenames [Array<String>] an array of mock data filenames
  # @param mock_data_directory [String] the name of the directory mocked data files are stored in
  # @return [Array<Hash>] an array of hashes, each containing data parsed from the mock data files
  def self.parse_mock_files(mock_data_filenames, mock_data_directory)
    mock_data_filenames.map do |fn|
      file_path = File.join(mock_data_directory, fn)
      file_text = File.open(file_path).read

      JSON.parse(file_text)
    end
  end

  # Returns the mock Hypatia response associated with `media_url`
  #
  # @!scope module
  # @param mock_data [Hash] a hash mapping URLs to mocked response bodies
  # @param media_url [String] the media post URL to return a mock Hypatia response for
  # @return [Typhoeus::Response] a Typhoeus response with a body containing mocked data
  def self.generate_force_response(mock_data, media_url)
    mock_body = mock_data[media_url]
    mock_body = Marshal.load(Marshal.dump(mock_body))  # make a "deep copy" of mock_body to avoid mutating the mock_data hash

    # Stringify the mock body and the scrape_result attribute of mock_body to imitate Hypatia's JSON serialization
    mock_body["scrape_result"] = JSON.dump(mock_body["scrape_result"])
    mock_body = JSON.dump(mock_body)

    Typhoeus::Response.new(body: mock_body, code: 200)
  end

  # Returns a simple {success: true} response, imitating Hypatia's response to non-force scrape requests
  #
  # @!scope module
  # @return [Typhoeus::Response] A Typhoeus response containing a queue success message
  def self.generate_nonforce_response
    success_message = { success: true }
    Typhoeus::Response.new(body: JSON.dump(success_message), code: 200)
  end

  # Raises an error if the `mock_data` hash doesn't have a key matching `media_url`
  # This requires us to add new data to our mock when we use new URLs in tests
  # But it in doing so, it prevents us from hitting live Hypatia in tests
  #
  # @!scope module
  # @param mock_data [Hash] a hash mapping URLs to mocked response bodies
  # @param media_url [String] the media post URL to return a mock Hypatia response for
  # @return nil
  def self.ensure_media_url_is_mocked(mock_data, media_url)
    unless mock_data.has_key?(media_url)
      raise URLNotMockedError, "URL #{media_url}, was not caught by the Typhoeus testing mock. Please use an already mocked URL in your test or update the mock with this URL."
    end
  end

  # Stubs Typhoeus requests to Hypatia.
  #
  # @!scope module
  # @return nil
  def self.construct_typhoeus_hypatia_stub
    mock_data = ingest_mock_data

    Typhoeus.stub(ENV["HYPATIA_SERVER_URL"]) do |request|
      media_url = request.options[:params][:url]
      ensure_media_url_is_mocked(mock_data, media_url)

      should_force_request = request.options[:params][:force] == true
      should_force_request ? generate_force_response(mock_data, media_url) : generate_nonforce_response
    end
  end

  construct_typhoeus_hypatia_stub
end
