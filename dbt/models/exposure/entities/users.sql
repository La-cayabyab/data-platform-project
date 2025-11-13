WITH

users AS (SELECT * FROM {{ ref('stg__users') }})

, posts AS (SELECT * FROM {{ ref('int_agg__posts__user') }})

SELECT
    users.user_id
    , COALESCE(posts.count_distinct_posts, 0) AS count_distinct_posts

FROM users
    LEFT JOIN posts 
        ON users.user_id = posts.user_id
