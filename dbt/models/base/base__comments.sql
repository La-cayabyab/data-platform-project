WITH comments AS (SELECT * FROM {{ source('google_cloud_storage', 'comments') }})

SELECT
    CONCAT(_file, CAST(_line AS STRING))   AS file_comment_id
    , CAST(_line AS INT64)                 AS comment_id
    , JSON_EXTRACT_SCALAR(_data, '$.body') AS comment_content
    , CAST(_modified AS TIMESTAMP)         AS comment_modified_datetime_utc
    , CAST(_fivetran_synced AS TIMESTAMP)  AS fivetran_synced_datetime_utc

FROM comments
