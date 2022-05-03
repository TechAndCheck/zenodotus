# typed: ignore
require "shrine"

require "shrine/storage/file_system"
require "shrine/storage/memory"
require "shrine/storage/s3"

# Available buckets are `zenodotus-testing` (24-hour expiration) and `zenodotus-production` (permanant)
def make_s3_bucket(bucket_name)
  Shrine::Storage::S3.new(
    bucket: bucket_name, # required
    region: "us-east-1", # required
    access_key_id: Figaro.env.AWS_ACCESS_KEY,
    secret_access_key: Figaro.env.AWS_ACCESS_SECRET,
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
  case Rails.env
  when "development"
    Figaro.env.USE_S3_DEV_TEST == "true" ? make_s3_bucket("zenodotus-testing") : Shrine::Storage::FileSystem.new("public", prefix: "uploads")
  when "test"
    Figaro.env.USE_S3_DEV_TEST == "true" ? make_s3_bucket("zenodotus-testing") : Shrine::Storage::Memory.new
  when "production"
    make_s3_bucket("zenodotus-production")
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
