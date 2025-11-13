WITH users AS (SELECT * FROM {{ ref('base__users') }})

SELECT
    user_id
    , username
    , user_email_address
    , user_full_name
    , user_company_address
    , user_modified_datetime_utc

FROM users

QUALIFY ROW_NUMBER() OVER 
    (PARTITION BY user_id 
    ORDER BY 
        fivetran_synced_datetime_utc DESC
        , user_modified_datetime_utc DESC
    ) = 1