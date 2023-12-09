{{ config(
    materialized='incremental', 
    unique_key='user_id',
    target_schema='staging',
    target_table='users'
) }}

-- Al ser incremental, sabemos que no es una vista porque no existe un modelo incremental con vistas
WITH src_users AS (
    SELECT * FROM {{ source('sql_server_dbo', 'users') }}
),

stg_users AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key(['user_id']) }} AS VARCHAR(50)) AS user_id,
        updated_at,
        CAST(address_id AS varchar(50)) AS address_id,
        total_orders,   -- lo borramos porque viene vacío--
        CAST(last_name AS varchar(20)) AS last_name,
        created_at,
        CAST(REPLACE(phone_number, '-', '') AS number) AS phone_number,
        CAST(first_name AS varchar(20)) AS first_name,
        CAST(email AS varchar(50)) AS email,
        _fivetran_deleted,
        _fivetran_synced AS f_carga
    FROM src_users
)

SELECT * FROM stg_users
