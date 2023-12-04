{{
  config(
    materialized='table',
    unique_key=['event_id']
  )
}}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_events') }}
),


fct_events AS (

    select
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at,
        order_id,
        date_load

FROM stg_events

)

SELECT * FROM fct_events