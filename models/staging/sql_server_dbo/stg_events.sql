{{ config(
    materialized='incremental',
    unique_key = 'event_id',
    target_schema='staging',
    target_table='events'
    ) 
    }}

WITH stg_events AS (
    SELECT * FROM {{ source('sql_server_dbo', 'events') }}

),

renamed_cast AS (

    select
        {{ dbt_utils.generate_surrogate_key(['event_id']) }} AS event_id,
        cast(page_url as varchar(300)) as page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at,
        order_id,
        cast(_fivetran_deleted as boolean) as _fivetran_deleted,
        cast(_fivetran_synced as timestamp) as date_load

FROM stg_events

)

SELECT * FROM renamed_cast
