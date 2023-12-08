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
        {{ dbt_utils.generate_surrogate_key(['event_id']) }} AS event_id,
        cast(page_url as varchar(300)) as page_url,
        event_type,
        user_id,
        cast(product_id as varchar (50)) as product_id,
        cast(session_id as varchar (50)) as session_id,
        created_at,
        cast(order_id as varchar (50)) as order_id,
        cast(_fivetran_deleted as boolean) as _fivetran_deleted,
        cast(_fivetran_synced as timestamp) as date_load

FROM src_events

)

SELECT * FROM stg_events
