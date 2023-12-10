{{ config(
    materialized='incremental', 
    unique_key='user_id',
    target_schema='staging',
    target_table='users'
) }}

WITH src_users AS (
    SELECT * FROM {{ source('sql_server_dbo', 'users') }}
),

stg_users AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key(['user_id']) }} AS VARCHAR(50)) AS user_id,
        CAST(updated_at AS TIMESTAMP_NTZ) AS updated_at,
        CAST(address_id AS VARCHAR(50)) AS address_id,
        CAST(total_orders AS INT) AS total_orders,
        CAST(last_name AS VARCHAR(20)) AS last_name,
        CAST(created_at AS TIMESTAMP_NTZ) AS created_at,
        CAST(REPLACE(phone_number, '-', '') AS VARCHAR(20)) AS phone_number,
        CAST(first_name AS VARCHAR(20)) AS first_name,
        CAST(email AS VARCHAR(50)) AS email,
        CAST(_fivetran_deleted AS BOOLEAN) AS _fivetran_deleted,
        CAST(_fivetran_synced AS TIMESTAMP_NTZ) AS f_carga
    FROM src_users
)

SELECT * FROM stg_users
