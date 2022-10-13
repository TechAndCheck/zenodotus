module AwsS3Mock
  class MediaNotMockedError < StandardError; end

  # Raises an error if no file name in the `test/mocks/media` folder matches the `object_key` param
  # This requires us to add new media to our mocks directory when we use new URLs in tests
  # But it in doing so, it prevents us from hitting live s3 in tests (so long as we apply the s3 stub in a test file)
  #
  # @!scope class
  # @param mock_media_filenames [Array] an array of mock media file names
  # @param bucket_name [String] the bucket prefix of the s3 object being requested
  # @param object_key [String] the key of the s3 object being requested
  # @return nil
  def self.ensure_s3_key_mocked(mock_media_filenames, bucket_name, object_key)
    unless mock_media_filenames.include?(object_key)
      raise MediaNotMockedError, "s3://#{bucket_name}/#{object_key} was not caught by the S3 mock. Please add #{object_key} to the test/mock_media directory."
    end
  end

  # Mocks the AwsS3Downloader.download_file_in_s3_received_from_hypatia method
  # Returns the name of a file in the test/mocks/media directory that matches the `object_key` parameter
  #
  # @!scope class
  # @param object_key [String] the key of the s3 object being requested
  # @return [String] the path to the media file matching the `object_key` param
  def self.download_file_in_s3_received_from_hypatia(object_key)
    bucket_name = Figaro.env.AWS_S3_BUCKET_NAME_HYPATIA  # not used in the mock. We store all mocked media in one folder
    download_from_s3(object_key, bucket_name, "")
  end

  # Mocks the AwsS3Downloader.download_from_s3 method
  # Ensures that the we have a local media file matching the object_key param
  # If we do, returns the corresponding filename. If not, raises MediaNotMockederror
  #
  # @param object_key [String] the key of the s3 object being requested
  # @param bucket_name [String] the name of the s3 bucket the key is located in. Not used in this mock
  # @param local_path [String] the real s3 downloader uses this param as a save path. It isn't used in this mock.
  # @return [String] the path to the media file matching the object_key param
  def self.download_from_s3(object_key, bucket_name, local_path)
    mock_media_directory = File.join(File.dirname(__FILE__), "media")
    mock_media_filenames = Dir.children(mock_media_directory)

    ensure_s3_key_mocked(mock_media_filenames, bucket_name, object_key)

    media_file_path = File.join(mock_media_directory, object_key)
    media_file_path
  end
end
