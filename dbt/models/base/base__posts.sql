WITH posts AS (SELECT * FROM {{ source('google_cloud_storage', 'posts') }})

SELECT
    CONCAT(_file, CAST(_line AS STRING))   AS file_post_id
    , CAST(_line AS INT64)                 AS post_id
    , JSON_EXTRACT_SCALAR(_data, '$.body') AS post_content
    , CAST(_modified AS TIMESTAMP)         AS post_modified_datetime_utc
    , CAST(_fivetran_synced AS TIMESTAMP)  AS fivetran_synced_datetime_utc

FROM posts
