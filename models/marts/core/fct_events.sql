{{ config(
    materialized='incremental',
    unique_key='event_id'
) 
}}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_events') }}
),

event_users AS (
    SELECT
        user_id,
        SUM(CASE WHEN event_type = 'checkout' THEN 1 END) as checkout_amount,
        SUM(CASE WHEN event_type = 'package_shipped' THEN 1 END) as package_shipped_amount,
        SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 END) as add_to_cart_amount,
        SUM(CASE WHEN event_type = 'page_view' THEN 1 END) as page_view_amount
    FROM stg_events
    GROUP BY 1
),

intermediate_events AS (
    SELECT * 
    FROM {{ ref('intermediate_events') }}
),

fct_events AS (
    SELECT
        e.event_id,
        e.page_url,
        e.event_type,
        e.product_id,
        e.session_id,
        e.created_at,
        e.order_id,
        e.date_load,
        COALESCE(e.product_name, 'No product involved') as product_name,
        eu.user_id,
        eu.checkout_amount,
        eu.package_shipped_amount,
        eu.add_to_cart_amount,
        eu.page_view_amount
    FROM intermediate_events e
    LEFT JOIN event_users eu ON e.user_id = eu.user_id
)

SELECT * FROM fct_events

