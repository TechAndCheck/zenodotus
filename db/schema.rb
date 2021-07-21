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

ActiveRecord::Schema.define(version: 2021_07_21_160205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "archive_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archivable_entity_id", null: false
    t.string "archivable_entity_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "archive_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "archivable_item_id", null: false
    t.string "archivable_item_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "image_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "dhash"
    t.jsonb "image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "instagram_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instagram_post_id"
    t.jsonb "image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "dhash"
    t.index ["instagram_post_id"], name: "index_instagram_images_on_instagram_post_id"
  end

  create_table "instagram_posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text", null: false
    t.string "instagram_id", null: false
    t.datetime "posted_at", null: false
    t.integer "number_of_likes", null: false
    t.uuid "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "url", null: false
    t.string "profile_image_url", null: false
    t.jsonb "profile_image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "instagram_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "instagram_post_id"
    t.jsonb "video_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["instagram_post_id"], name: "index_instagram_videos_on_instagram_post_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.uuid "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "profile_image_data"
    t.integer "followers_count", null: false
    t.integer "following_count", null: false
  end

  create_table "twitter_videos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.jsonb "video_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_twitter_videos_on_tweet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "instagram_images", "instagram_posts"
  add_foreign_key "instagram_videos", "instagram_posts"
  add_foreign_key "twitter_images", "tweets"
  add_foreign_key "twitter_videos", "tweets"

  create_view "unified_posts", materialized: true, sql_definition: <<-SQL
      WITH post_details AS (
           SELECT tweets.id AS post_id,
              tweets.text,
              tweets.author_id,
              tweets.posted_at,
              NULL::integer AS number_of_likes,
              'tweet'::text AS post_type
             FROM tweets
          UNION ALL
           SELECT instagram_posts.id AS post_id,
              instagram_posts.text,
              instagram_posts.author_id,
              instagram_posts.posted_at,
              instagram_posts.number_of_likes,
              'instagram_post'::text AS post_type
             FROM instagram_posts
          ), some_user_details AS (
           SELECT DISTINCT instagram_users.id AS author_id,
              instagram_users.display_name,
              instagram_users.handle,
              instagram_users.followers_count,
              instagram_users.following_count,
              instagram_users.profile,
              NULL::text AS description,
              instagram_users.profile_image_url
             FROM instagram_users,
              post_details
            WHERE (post_details.author_id = instagram_users.id)
          UNION ALL
           SELECT DISTINCT twitter_users.id AS author_id,
              twitter_users.display_name,
              twitter_users.handle,
              twitter_users.followers_count,
              twitter_users.following_count,
              NULL::text AS profile,
              twitter_users.description,
              twitter_users.profile_image_url
             FROM twitter_users,
              post_details
            WHERE (post_details.author_id = twitter_users.id)
          ), media_details AS (
           SELECT instagram_images.instagram_post_id AS post_id,
              instagram_images.image_data,
              NULL::jsonb AS video_data
             FROM instagram_images
          UNION ALL
           SELECT instagram_videos.instagram_post_id AS post_id,
              NULL::jsonb AS image_data,
              instagram_videos.video_data
             FROM instagram_videos
          UNION ALL (
                   SELECT twitter_images.tweet_id AS post_id,
                      twitter_images.image_data,
                      NULL::jsonb AS video_data
                     FROM twitter_images
                  UNION ALL
                   SELECT twitter_videos.tweet_id AS post_id,
                      NULL::jsonb AS image_data,
                      twitter_videos.video_data
                     FROM twitter_videos
          )
          ), posts_with_media AS (
           SELECT post_details.post_id,
              post_details.text,
              post_details.author_id,
              post_details.posted_at,
              post_details.number_of_likes,
              post_details.post_type,
              media_details.image_data,
              media_details.video_data
             FROM (post_details
               FULL JOIN media_details ON ((post_details.post_id = media_details.post_id)))
          )
   SELECT posts_with_media.post_id,
      posts_with_media.post_type,
      posts_with_media.text,
      posts_with_media.author_id,
      posts_with_media.posted_at,
      posts_with_media.number_of_likes,
      posts_with_media.image_data,
      posts_with_media.video_data,
      some_user_details.display_name,
      some_user_details.handle,
      some_user_details.followers_count,
      some_user_details.following_count,
      some_user_details.profile,
      some_user_details.description,
      some_user_details.profile_image_url
     FROM (posts_with_media
       JOIN some_user_details ON ((posts_with_media.author_id = some_user_details.author_id)));
  SQL
  create_view "unified_users", materialized: true, sql_definition: <<-SQL
      SELECT instagram_users.id AS author_id,
      instagram_users.display_name,
      instagram_users.handle,
      instagram_users.followers_count,
      instagram_users.following_count,
      instagram_users.profile,
      NULL::text AS description,
      instagram_users.profile_image_url,
      'instagram_user'::text AS user_type
     FROM instagram_users
  UNION ALL
   SELECT twitter_users.id AS author_id,
      twitter_users.display_name,
      twitter_users.handle,
      twitter_users.followers_count,
      twitter_users.following_count,
      NULL::text AS profile,
      twitter_users.description,
      twitter_users.profile_image_url,
      'twitter_user'::text AS user_type
     FROM twitter_users;
  SQL
end
