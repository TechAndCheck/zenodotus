WITH post_details AS
         (SELECT id AS post_id, text, author_id,
                 posted_at,
                 NULL AS number_of_likes,
                 'tweet' AS post_type
          FROM tweets
          UNION ALL SELECT id AS post_id, text, author_id,
                           posted_at,
                           number_of_likes,
                           'instagram_post' as post_type
          FROM instagram_posts),
     some_user_details AS
         (SELECT DISTINCT id AS author_id,
                          display_name,
                          handle,
                          followers_count,
                          following_count,
                          "profile",
                          NULL AS description,
                          profile_image_data
          FROM instagram_users,
               post_details
          WHERE post_details.author_id = instagram_users.id
          UNION ALL
          (SELECT DISTINCT id AS author_id,
                           display_name,
                           handle,
                           followers_count,
                           following_count,
                           NULL AS "profile",
                           description,
                           profile_image_data
           FROM twitter_users,
                post_details
           WHERE post_details.author_id = twitter_users.id)),
     media_details AS (
         (SELECT instagram_post_id AS post_id,
                 image_data,
                 NULL AS video_data
          FROM instagram_images
          UNION ALL SELECT instagram_post_id AS post_id,
                           NULL AS image_data,
                           video_data
          FROM instagram_videos)
         UNION ALL
         (SELECT tweet_id AS post_id,
                 image_data,
                 NULL AS video_data
          FROM twitter_images
          UNION ALL SELECT tweet_id AS post_id,
                           NULL AS image_data,
                           video_data
          FROM twitter_videos)) ,
     posts_with_media AS
         (SELECT post_details.*,
                 image_data,
                 video_data
          FROM post_details
                   FULL OUTER JOIN media_details ON (post_details.post_id = media_details.post_id))
SELECT post_id, post_type, text, posts_with_media.author_id, posted_at, number_of_likes, image_data, video_data, display_name, handle, followers_count, following_count, profile, description, profile_image_data
FROM posts_with_media
         INNER JOIN some_user_details ON (posts_with_media.author_id = some_user_details.author_id)
