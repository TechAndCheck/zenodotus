module AwsS3Mock
  class MediaNotMockedError < StandardError; end
  class S3Mock
    # Raises an error if the object key passed in doesn't match a file name in the test/mock_media directory
    #
    # @!scope class
    # @params mock_media_filenames [Array] An array of mock media file names
    # @params bucket_name [String] The bucket prefix of the s3 object being requested
    # @params object_key [String] The key of the s3 object being requested
    # @return nil
    def self.ensure_s3_key_mocked(mock_media_filenames, bucket_name, object_key)
      unless mock_media_filenames.include? object_key
        raise MediaNotMockedError, "s3://#{bucket_name}/#{object_key} was not caught by the S3 mock. Please add #{object_key} to the test/mock_media directory."
      end
    end

    # Mocks the AwsS3Downloader.download_file_in_s3_received_from_hypatia method
    # Returns a media filename in the test/mock_media directory that matches the object key parameter
    #
    # @!scope class
    # @params object_key [String] The key of the s3 object being requested
    # @return [String] The path to the media file matching the object_key param
    def self.download_file_in_s3_received_from_hypatia(object_key)
      bucket_name = Figaro.env.AWS_S3_BUCKET_NAME_HYPATIA  # not actually needed in the mock :)
      download_from_s3(object_key, bucket_name, "")
    end

    # Mocks the AwsS3Downloader.download_from_s3 method
    # Ensures that the we have a local media file matching the object_key param
    # If we do, returns the corresponding filename
    #
    # @params object_key [String] The key of the s3 object being requested
    # @params bucket_name [String] The name of the s3 bucket the key is located in. Not used in this mock
    # @params local_path [String] The real s3 downloader uses this param as a save path. It isn't used in this mock.
    # @return [String] The path to the media file matching the object_key param
    def self.download_from_s3(object_key, bucket_name, local_path)
      mock_media_directory = File.join(File.dirname(__FILE__), "mock_media")
      mock_media_filenames = Dir.children(mock_media_directory)

      ensure_s3_key_mocked(mock_media_filenames, bucket_name, object_key)

      media_file_path = File.join(mock_media_directory, object_key)
      media_file_path
    end
  end
end
