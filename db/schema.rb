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

ActiveRecord::Schema[7.2].define(version: 2024_12_13_021724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "applicant_status", ["approved", "rejected"]
  create_enum "scrape_type", ["instagram", "facebook", "twitter", "youtube", "tiktok"]

  create_table "ahoy_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "visit_id"
    t.uuid "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.uuid "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

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

  create_table "applicants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "affiliation"
    t.string "primary_role"
    t.text "use_case"
    t.datetime "accepted_terms_at"
    t.datetime "accepted_terms_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.enum "status", enum_type: "applicant_status"
    t.datetime "reviewed_at", precision: nil
    t.text "review_note"
    t.text "review_note_internal"
    t.uuid "user_id"
    t.string "source_site"
    t.uuid "reviewer_id"
    t.index ["confirmation_token"], name: "index_applicants_on_confirmation_token", unique: true
    t.index ["reviewer_id"], name: "index_applicants_on_reviewer_id"
    t.index ["user_id"], name: "index_applicants_on_user_id"
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
    t.datetime "posted_at"
    t.boolean "private", default: false, null: false
    t.string "url"
    t.string "public_id", null: false
    t.index ["public_id"], name: "index_archive_items_on_public_id", unique: true
    t.index ["submitter_id"], name: "index_archive_items_on_submitter_id"
    t.index ["url"], name: "index_archive_items_on_url"
  end

  create_table "archive_items_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archive_item_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_item_id", "user_id"], name: "index_archive_items_users_on_archive_item_id_and_user_id", unique: true
    t.index ["archive_item_id"], name: "index_archive_items_users_on_archive_item_id"
    t.index ["user_id"], name: "index_archive_items_users_on_user_id"
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "claim_reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "claim_reviewed"
    t.text "url"
    t.jsonb "author"
    t.datetime "date_published"
    t.jsonb "item_reviewed"
    t.jsonb "review_rating"
    t.uuid "media_review_id"
    t.uuid "external_unique_id"
    t.uuid "claim_review_author_id"
    t.index ["claim_review_author_id"], name: "index_claim_reviews_on_claim_review_author_id"
    t.index ["media_review_id"], name: "index_claim_reviews_on_media_review_id"
  end

  create_table "corpus_downloads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "download_type", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_corpus_downloads_on_user_id"
  end

  create_table "crawlable_sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "starting_url"
    t.datetime "last_run"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_run_time"
    t.integer "number_of_claims_found", default: 0, null: false
    t.datetime "last_heartbeat_at"
    t.datetime "last_run_finished_at"
  end

  create_table "crawler_runs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "starting_url", null: false
    t.string "host_name", null: false
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.integer "number_of_pages_scraped", default: 0, null: false
    t.integer "number_of_new_claims_found", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facebook_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "facebook_post_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_post_id"], name: "index_facebook_images_on_facebook_post_id"
  end

  create_table "facebook_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "posted_at", precision: nil
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

  create_table "fact_check_organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "host_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "google_search_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text"
    t.string "claimant"
    t.datetime "claim_date"
    t.string "url"
    t.datetime "review_date"
    t.string "rating"
    t.string "title"
    t.string "language_code"
    t.string "publisher_name"
    t.string "publisher_site"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_hashes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "dhash"
    t.uuid "archive_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.jsonb "dhashes", array: true
    t.jsonb "video_data"
    t.boolean "private", default: false, null: false
    t.index ["user_id"], name: "index_image_searches_on_user_id"
  end

  create_table "instagram_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instagram_post_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instagram_post_id"], name: "index_instagram_images_on_instagram_post_id"
  end

  create_table "instagram_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "instagram_id", null: false
    t.datetime "posted_at", precision: nil, null: false
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
    t.text "original_media_link"
    t.text "media_authenticity_category"
    t.text "original_media_context_description"
    t.uuid "archive_item_id"
    t.boolean "taken_down"
    t.jsonb "author"
    t.datetime "date_published"
    t.jsonb "item_reviewed"
    t.text "url"
    t.jsonb "media_item_appearance"
    t.uuid "external_unique_id"
    t.boolean "invalid_url", default: false
    t.string "media_url"
    t.string "original_media_review"
    t.uuid "media_review_author_id"
    t.index ["archive_item_id"], name: "index_media_reviews_on_archive_item_id"
    t.index ["media_review_author_id"], name: "index_media_reviews_on_media_review_author_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.uuid "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "content_tsvector", type: :tsvector, as: "to_tsvector('english'::regconfig, content)", stored: true
    t.boolean "private", default: false, null: false
    t.uuid "user_id", array: true
    t.index ["content_tsvector"], name: "index_pg_search_documents_on_content_tsvector", using: :gin
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "scrapes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "fulfilled", default: false, null: false
    t.string "url", null: false
    t.enum "scrape_type", null: false, enum_type: "scrape_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "error", default: false, null: false
    t.boolean "removed", default: false
    t.uuid "media_review_id"
    t.uuid "user_id"
    t.index ["media_review_id"], name: "index_scrapes_on_media_review_id"
  end

  create_table "screenshots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archive_item_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archive_item_id"], name: "index_screenshots_on_archive_item_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.uuid "taggable_id"
    t.string "tagger_type"
    t.uuid "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "text_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "query"
    t.uuid "user_id"
    t.boolean "private", default: false, null: false
    t.index ["user_id"], name: "index_text_searches_on_user_id"
  end

  create_table "tik_tok_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "tik_tok_id", null: false
    t.datetime "posted_at", precision: nil, null: false
    t.integer "number_of_likes", null: false
    t.uuid "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tiktok_posts_on_author_id"
  end

  create_table "tik_tok_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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

  create_table "tik_tok_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tik_tok_post_id"
    t.jsonb "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tik_tok_post_id"], name: "index_tik_tok_videos_on_instagram_post_id"
  end

  create_table "tweets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "twitter_id", null: false
    t.string "language", null: false
    t.uuid "author_id", null: false
    t.datetime "posted_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_tweets_on_author_id"
  end

  create_table "twitter_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.jsonb "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_twitter_images_on_tweet_id"
  end

  create_table "twitter_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "handle", null: false
    t.string "display_name", null: false
    t.datetime "sign_up_date", precision: nil, null: false
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

  create_table "user_remote_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "hashed_remote_key", null: false
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.string "last_used_ip"
    t.string "last_used_user_agent"
    t.string "last_used_referer"
    t.string "last_used_origin"
    t.string "last_used_path"
    t.string "last_used_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_remote_key"], name: "index_user_remote_keys_on_hashed_remote_key", unique: true
    t.index ["user_id"], name: "index_user_remote_keys_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "webauthn_id"
    t.string "hashed_recovery_codes", default: [], null: false, array: true
    t.string "totp_secret"
    t.boolean "totp_confirmed", default: false
    t.uuid "remote_key_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["webauthn_id"], name: "index_users_on_webauthn_id", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "webauthn_credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "external_id", null: false
    t.string "public_key", null: false
    t.string "nickname", null: false
    t.integer "sign_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key_type", null: false
    t.index ["external_id"], name: "index_webauthn_credentials_on_external_id", unique: true
    t.index ["nickname", "user_id"], name: "index_webauthn_credentials_on_nickname_and_user_id", unique: true
    t.index ["user_id"], name: "index_webauthn_credentials_on_user_id"
  end

  create_table "youtube_channels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "youtube_id", null: false
    t.bigint "num_views", null: false
    t.integer "num_subscribers", null: false
    t.integer "num_videos", null: false
    t.boolean "made_for_kids"
    t.datetime "sign_up_date", null: false
    t.jsonb "channel_image_data", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "youtube_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "youtube_id", null: false
    t.bigint "num_views", null: false
    t.integer "num_likes", null: false
    t.datetime "posted_at", null: false
    t.bigint "duration", null: false
    t.boolean "live", null: false
    t.integer "num_comments"
    t.string "language"
    t.string "channel_id"
    t.boolean "made_for_kids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "youtube_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "youtube_post_id"
    t.jsonb "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["youtube_post_id"], name: "index_youtube_videos_on_youtube_post_id"
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "archive_items_users", "archive_items"
  add_foreign_key "archive_items_users", "users"
  add_foreign_key "claim_reviews", "fact_check_organizations", column: "claim_review_author_id"
  add_foreign_key "claim_reviews", "media_reviews"
  add_foreign_key "corpus_downloads", "users"
  add_foreign_key "facebook_images", "facebook_posts"
  add_foreign_key "facebook_videos", "facebook_posts"
  add_foreign_key "image_searches", "users"
  add_foreign_key "instagram_images", "instagram_posts"
  add_foreign_key "instagram_videos", "instagram_posts"
  add_foreign_key "media_reviews", "archive_items"
  add_foreign_key "media_reviews", "fact_check_organizations", column: "media_review_author_id"
  add_foreign_key "screenshots", "archive_items"
  add_foreign_key "taggings", "tags"
  add_foreign_key "text_searches", "users"
  add_foreign_key "twitter_images", "tweets"
  add_foreign_key "twitter_videos", "tweets"
  add_foreign_key "user_remote_keys", "users"
  add_foreign_key "webauthn_credentials", "users"
  add_foreign_key "youtube_videos", "youtube_posts"
end
