{{ config(
    materialized='view',
    unique_key = 'user_id',
    target_schema='core',
    target_table='intermediate_users'
) 
}}

WITH snapshot_users AS (
    SELECT *
    FROM {{ ref('snapshot_users') }}
    {% if is_incremental() %}
    WHERE date_load > (SELECT max(date_load) FROM {{ this }})
    {% endif %}
),

stg_addresses AS (
    SELECT *
    FROM {{ ref('stg_addresses') }}
),

intermediate_users AS (
    SELECT
        u.user_id 
        , a.address_id
        , u.created_at
        , u.first_name
        , u.last_name
        , u.phone_number
        , u.email
        , u.updated_at
        , u.date_load
    FROM snapshot_users u
    LEFT JOIN stg_addresses a ON u.address_id = a.address_id
)

SELECT * FROM intermediate_users
