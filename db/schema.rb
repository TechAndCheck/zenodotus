# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_28_155140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "scrape_type", ["instagram", "facebook", "twitter"]

  create_table "api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "hashed_api_key"
    t.uuid "user_id"
    t.date "last_used"
    t.jsonb "usage_logs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_api_key"], name: "index_api_keys_on_hashed_api_key"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "archive_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archivable_entity_id", null: false
    t.string "archivable_entity_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "archive_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archivable_item_id", null: false
    t.string "archivable_item_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "submitter_id"
    t.uuid "scrape_id"
    t.index ["submitter_id"], name: "index_archive_items_on_submitter_id"
  end

  create_table "facebook_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facebook_post_id"
    t.jsonb "image_data"
    t.string "dhash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_post_id"], name: "index_facebook_images_on_facebook_post_id"
  end

  create_table "facebook_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "posted_at"
    t.text "text"
    t.text "facebook_id"
    t.uuid "author_id", null: false
    t.jsonb "reactions"
    t.integer "num_comments"
    t.integer "num_shares"
    t.integer "num_views"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "url", null: false
    t.index ["author_id"], name: "index_facebook_posts_on_author_id"
  end

  create_table "facebook_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "facebook_id"
    t.string "name"
    t.boolean "verified"
    t.string "profile"
    t.integer "followers_count"
    t.integer "likes_count"
    t.string "url"
    t.jsonb "profile_image_data"
    t.string "profile_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facebook_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facebook_post_id"
    t.jsonb "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_post_id"], name: "index_facebook_videos_on_facebook_post_id"
  end

  create_table "image_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "dhash"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_image_searches_on_user_id"
  end

  create_table "instagram_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instagram_post_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dhash"
    t.index ["instagram_post_id"], name: "index_instagram_images_on_instagram_post_id"
  end

  create_table "instagram_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "instagram_id", null: false
    t.datetime "posted_at", null: false
    t.integer "number_of_likes", null: false
    t.uuid "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_instagram_posts_on_author_id"
  end

  create_table "instagram_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_name", null: false
    t.string "handle", null: false
    t.integer "number_of_posts", null: false
    t.integer "followers_count", null: false
    t.integer "following_count", null: false
    t.boolean "verified", null: false
    t.text "profile", null: false
    t.string "url"
    t.string "profile_image_url", null: false
    t.jsonb "profile_image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instagram_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instagram_post_id"
    t.jsonb "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instagram_post_id"], name: "index_instagram_videos_on_instagram_post_id"
  end

  create_table "media_reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "original_media_link", null: false
    t.text "media_authenticity_category", null: false
    t.text "original_media_context_description", null: false
    t.uuid "archive_item_id", null: false
    t.index ["archive_item_id"], name: "index_media_reviews_on_archive_item_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_organizations_on_admin_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.uuid "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "content_tsvector", type: :tsvector, as: "to_tsvector('english'::regconfig, content)", stored: true
    t.index ["content_tsvector"], name: "index_pg_search_documents_on_content_tsvector", using: :gin
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "scrapes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "fulfilled", default: false, null: false
    t.string "url", null: false
    t.enum "scrape_type", null: false, enum_type: "scrape_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "query"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_text_searches_on_user_id"
  end

  create_table "tweets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "twitter_id", null: false
    t.string "language", null: false
    t.uuid "author_id", null: false
    t.datetime "posted_at", null: false
    t.index ["author_id"], name: "index_tweets_on_author_id"
  end

  create_table "twitter_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dhash"
    t.index ["tweet_id"], name: "index_twitter_images_on_tweet_id"
  end

  create_table "twitter_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "handle", null: false
    t.string "display_name", null: false
    t.datetime "sign_up_date", null: false
    t.string "twitter_id", null: false
    t.text "description", null: false
    t.string "url", null: false
    t.text "profile_image_url", null: false
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "profile_image_data"
    t.integer "followers_count", null: false
    t.integer "following_count", null: false
  end

  create_table "twitter_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.jsonb "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "video_type"
    t.index ["tweet_id"], name: "index_twitter_videos_on_tweet_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.boolean "restricted", default: false, null: false
    t.uuid "organization_id", null: false
    t.boolean "super_admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "facebook_images", "facebook_posts"
  add_foreign_key "facebook_videos", "facebook_posts"
  add_foreign_key "image_searches", "users"
  add_foreign_key "instagram_images", "instagram_posts"
  add_foreign_key "instagram_videos", "instagram_posts"
  add_foreign_key "media_reviews", "archive_items"
  add_foreign_key "organizations", "users", column: "admin_id"
  add_foreign_key "text_searches", "users"
  add_foreign_key "twitter_images", "tweets"
  add_foreign_key "twitter_videos", "tweets"
end
