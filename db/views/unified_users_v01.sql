SELECT id AS author_id,
       display_name,
       handle,
       followers_count,
       following_count,
       profile,
       NULL AS description,
       profile_image_data,
       (
               to_tsvector('english', coalesce(instagram_users.handle, ''))
               || to_tsvector('english', coalesce(instagram_users.display_name, ''))
           ) as tsv_document,
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
        (
                to_tsvector('english', coalesce(twitter_users.handle, ''))
                || to_tsvector('english', coalesce(twitter_users.display_name, ''))
            ) as tsv_document,
        'twitter_user' as user_type
 FROM twitter_users)
