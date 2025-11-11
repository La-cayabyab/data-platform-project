WITH posts AS (SELECT * FROM {{ source('google_cloud_storage', 'posts') }})

SELECT
    CAST(_line AS INT64)                   AS post_id
    , CAST(_modified AS TIMESTAMP)         AS post_modified_datetime_utc
    , JSON_EXTRACT_SCALAR(_data, '$.body') AS post_content
    , CAST(_fivetran_synced AS TIMESTAMP)  AS fivetran_synced_datetime_utc

FROM posts