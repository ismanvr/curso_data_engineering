WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_users') }}
    ),

dim_users AS (
    SELECT
        user_id,
        updated_at,
        address_id,
        last_name,
        created_at,
        phone_number,
        first_name,
        email,
        f_carga
    FROM stg_users
    )

SELECT * FROM dim_users