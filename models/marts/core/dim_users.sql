{{
  config(
    materialized='incremental',
    unique_key=['user_id']
  )
}}

WITH intermediate_users AS (
    SELECT * 
    FROM {{ ref('intermediate_users') }}
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
        date_load
    FROM intermediate_users
    )

SELECT * FROM dim_users