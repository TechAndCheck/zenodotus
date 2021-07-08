SELECT id AS author_id,
                 display_name,
                 handle,
                 followers_count,
                 following_count,
                 "profile",
                 NULL AS description,
                 profile_image_url
 FROM instagram_users
 UNION ALL
 (SELECT id AS author_id,
                  display_name,
                  handle,
                  followers_count,
                  following_count,
                  NULL AS "profile",
                  description,
                  profile_image_url
  FROM twitter_users)
