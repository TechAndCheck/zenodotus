# typed: true
#
# This helps download files from AWS's S3 (or a compatible API such as CloudFlare's R2)
# To make this a bit less rough and tumble you have to implement a helper for each different bucket
# you want to access.
class AwsS3Downloader
  extend T::Sig
  extend T::Helpers


  # Download multiple url that was sent from Hypatia
  sig { params(urls: T::Array[String]).returns(T::Hash[String, String]) }
  def self.download_files_in_s3_received_from_hypatia(urls)
    downloads = {}
    urls.each { |url| downloads[url] = download_from_s3(object_key, bucket_name) }
    downloads
  end

  # Download single url that was sent from Hypatia
  sig { params(url: String).returns(String) }
  def self.download_file_in_s3_received_from_hypatia(url)
    bucket_name = Figaro.env.AWS_S3_BUCKET_NAME_HYPATIA
    object_key = "#{Figaro.env.AWS_S3_PATH_HYPATIA}#{File.basename(url)}"

    download_from_s3(object_key, bucket_name, Rails.root.join("tmp", object_key).to_s)
  end

private

  # A generic wrapper for downloading from any S3 bucket
  sig { params(object_key: String, bucket_name: String, local_path: String).returns(String) }
  def self.download_from_s3(object_key, bucket_name, local_path)
    s3_client = Aws::S3::Client.new(region: Figaro.env.AWS_REGION)

    s3_client.get_object(
      response_target: local_path,
      bucket: bucket_name,
      key: object_key
    )

    local_path
  end
end
