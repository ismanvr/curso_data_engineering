{{ config(
    materialized='incremental',
    unique_key = 'event_id',
    target_schema='staging',
    target_table='events'
    ) 
}}

WITH src_events AS (
    SELECT * FROM {{ source('sql_server_dbo', 'events') }}
),

stg_events AS (
    select
        CAST({{ dbt_utils.generate_surrogate_key(['event_id']) }} AS VARCHAR(50)) AS event_id,
        CAST(page_url as varchar(300)) as page_url,
        CAST(event_type as varchar(50)) as event_type,
        COALESCE(CAST({{ dbt_utils.generate_surrogate_key(['user_id']) }} AS VARCHAR(50)), 'N/A') AS user_id,
        COALESCE(CAST({{ dbt_utils.generate_surrogate_key(['product_id']) }} AS VARCHAR(50)), 'N/A') AS product_id,
        CAST(session_id as varchar (50)) as session_id,
        CAST(created_at as timestamp) as created_at,
        COALESCE(CAST({{ dbt_utils.generate_surrogate_key(['order_id']) }} AS VARCHAR(50)), 'N/A') AS order_id,
        CAST(_fivetran_deleted as boolean) as _fivetran_deleted,
        CAST(_fivetran_synced as timestamp) as date_load
    FROM src_events
)

SELECT * FROM stg_events
