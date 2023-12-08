{{
  config(
    materialized='table',
    unique_key=['user_id']
  )
}}

WITH snapshot_users AS (
    SELECT * 
    FROM {{ ref('snapshot_users') }}
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
    FROM snapshot_users
    )

SELECT * FROM dim_users