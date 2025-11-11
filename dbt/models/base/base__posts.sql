WITH posts AS (SELECT * FROM {{ source('google_cloud_storage', 'posts') }})

SELECT *
FROM posts