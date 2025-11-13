WITH users AS (SELECT * FROM {{ source('google_cloud_storage', 'users') }})

SELECT
    CONCAT(_file, CAST(_line AS STRING))                      AS file_user_id
    , CAST(_modified AS TIMESTAMP)                            AS user_modified_datetime_utc
    , CAST(_fivetran_synced AS TIMESTAMP)                     AS fivetran_synced_datetime_utc

    -- user/company metadata
    , LOWER(JSON_EXTRACT_SCALAR(_data, '$.id'))               AS user_id
    {# , CAST(_line AS INT64)                                 AS user_id #} -- initialized at 0 so parsed id from user metadata
    , LOWER(JSON_EXTRACT_SCALAR(_data, '$.username'))         AS username
    , LOWER(JSON_EXTRACT_SCALAR(_data, '$.email'))            AS user_email_address
    , INITCAP(JSON_EXTRACT_SCALAR(_data, '$.name'))           AS user_full_name

    , CONCAT(
        JSON_EXTRACT_SCALAR(_data, '$.address.street'), ' '
        ,JSON_EXTRACT_SCALAR(_data, '$.address.suite'), ', '
        ,JSON_EXTRACT_SCALAR(_data, '$.address.city'), ', '
        ,JSON_EXTRACT_SCALAR(_data, '$.address.zipcode')
    )                                                        AS user_company_address
FROM users

