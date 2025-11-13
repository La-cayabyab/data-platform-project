WITH posts AS (SELECT * FROM {{ ref('base__posts')}})

SELECT
    post_id
    , user_id
    , post_content
    , post_modified_datetime_utc
    , fivetran_synced_datetime_utc

FROM posts

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY post_id 
    ORDER BY 
        fivetran_synced_datetime_utc DESC
        , post_modified_datetime_utc DESC
    ) = 1