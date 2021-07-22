SELECT id AS author_id,
       display_name,
       handle,
       followers_count,
       following_count,
       profile,
       NULL AS description,
       profile_image_data,
       'instagram_user' as user_type
FROM instagram_users
UNION ALL
(SELECT id AS author_id,
        display_name,
        handle,
        followers_count,
        following_count,
        NULL AS profile,
        description,
        profile_image_data,
        'twitter_user' as user_type
 FROM twitter_users)
