WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_events') }}
),
stg_products AS (
    SELECT * 
    FROM {{ ref('stg_products') }}
),
stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_orders') }}
),
intermediate_events AS (
    SELECT 
        e.event_id,
        e.page_url,
        e.event_type,
        e.user_id,
        e.product_id,
        e.session_id,
        e.created_at,
        e.order_id,
        e.date_load,
        p.product_name,
        p.product_price,
        o.order_total,
        o.status
    FROM stg_events e
    LEFT JOIN stg_products p ON e.product_id = p.product_id
    LEFT JOIN stg_orders o ON e.order_id = o.order_id
)
SELECT * FROM intermediate_events
