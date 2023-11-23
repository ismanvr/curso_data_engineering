WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_users') }}
    ),

renamed_casted AS (
    SELECT *
    FROM stg_users
    )

SELECT * FROM renamed_casted