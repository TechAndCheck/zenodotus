# typed: ignore

require "shrine"

require "shrine/storage/file_system"
require "shrine/storage/memory"
require "shrine/storage/s3"


# Available buckets are `zenodotus-testing` (24-hour expiration) and `zenodotus-production` (permanant)
def make_s3_bucket(bucket_name, cdn_name = nil)
  Shrine::Storage::S3.new(
    bucket: bucket_name, # required
    region: "us-east-1", # required
    access_key_id: Figaro.env.AWS_ACCESS_KEY_ID,
    secret_access_key: Figaro.env.AWS_SECRET_ACCESS_KEY,
  )
end

def make_shrine_cache
  case Rails.env
  when "development"
    Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache")
  when "test"
    Shrine::Storage::Memory.new
  when "production"
    Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache")
  end
end

def make_shrine_storage
  bucket_name = Figaro.env.AWS_S3_BUCKET_NAME
  case Rails.env
  when "development"
    Figaro.env.USE_S3_DEV_TEST == "true" ? make_s3_bucket(bucket_name) : Shrine::Storage::FileSystem.new("public", prefix: "uploads")
  when "test"
    Figaro.env.USE_S3_DEV_TEST == "true" ? make_s3_bucket(bucket_name) : Shrine::Storage::Memory.new
  when "production"
    make_s3_bucket(bucket_name, ENV["CLOUDFRONT_HOST"])
  end
end

Shrine.storages = {
  cache: make_shrine_cache(),   # temporary
  store: make_shrine_storage(), # permanent
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :tempfile
Shrine.plugin :derivatives
Shrine.plugin :keep_files if ENV["STAGING"]
Shrine.plugin :remote_url, max_size: 20 * 1024 * 1024 # 20MB
Shrine.plugin :download_endpoint, prefix: "media/vault", host: "https://#{Figaro.env.PUBLIC_LINK_HOST}"
