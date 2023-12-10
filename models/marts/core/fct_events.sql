{{ config(
    materialized='incremental',
    unique_key='event_id'
) 
}}

WITH intermediate_events AS (
    SELECT * 
    FROM {{ ref('intermediate_events') }}
),

fct_events AS (
    SELECT
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at,
        order_id,
        date_load
    FROM intermediate_events
)

SELECT * FROM fct_events
