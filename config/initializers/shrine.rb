# typed: ignore
require "shrine"

# Development we want to be local, test ephemeral, production ???? (file for now)
case Rails.env
when "development"
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
when "test"
  require "shrine/storage/memory"

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new, # temporary
    store: Shrine::Storage::Memory.new       # permanent
  }
when "production"
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :derivatives
