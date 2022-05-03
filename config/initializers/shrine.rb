# typed: ignore
require "shrine"

require "shrine/storage/s3"

if Rails.env == "production" || Figaro.env.USE_S3_DEV_TEST == "true"
  s3_one_day_expiration = Shrine::Storage::S3.new(
    bucket: "zenodotus-testing", # required
    region: "us-east-1", # required
    access_key_id: Figaro.env.AWS_ACCESS_KEY,
    secret_access_key: Figaro.env.AWS_ACCESS_SECRET,
  )

  s3_permanent = Shrine::Storage::S3.new(
    bucket: "zenodotus-production", # required
    region: "us-east-1", # required
    access_key_id: Figaro.env.AWS_ACCESS_KEY,
    secret_access_key: Figaro.env.AWS_ACCESS_SECRET,
  )
end

# Development we want to be local, test ephemeral, production ???? (file for now)
case Rails.env
when "development"
  require "shrine/storage/file_system"

  storage = Figaro.env.USE_S3_DEV_TEST ? s3_one_day_expiration : Shrine::Storage::FileSystem.new("public", prefix: "uploads")
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: storage,                                                            # permanent
  }
when "test"
  require "shrine/storage/memory"

  storage = Figaro.env.USE_S3_DEV_TEST ? s3_one_day_expiration : Shrine::Storage::Memory.new

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new, # temporary
    store: storage,                     # permanent
  }
when "production"
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: s3_permanent,                                                       # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :tempfile
Shrine.plugin :derivatives
