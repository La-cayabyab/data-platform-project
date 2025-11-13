WITH stg__posts AS (SELECT * FROM {{ ref('stg__posts') }})

SELECT
    user_id
    , COUNT(DISTINCT post_id) AS count_distinct_posts

FROM stg__posts

GROUP BY user_id
