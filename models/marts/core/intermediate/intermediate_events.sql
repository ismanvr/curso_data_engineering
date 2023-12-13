{{ config(
    materialized='view',
    target_schema='core',
    target_table='intermediate_events'
) 
}}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_events') }}
{% if is_incremental() %}
    WHERE date_load > (SELECT max(date_load) FROM {{ this }})
    {% endif %}
),
stg_products AS (
    SELECT * 
    FROM {{ ref('stg_products') }}
),
stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_orders') }}
{% if is_incremental() %}
    WHERE date_load_utc > (SELECT max(date_load_utc) FROM {{ this }})
    {% endif %}
),
snapshot_users AS (
    SELECT *
    FROM {{ ref('snapshot_users') }}
{% if is_incremental() %}
    WHERE date_load > (SELECT max(date_load) FROM {{ this }})
    {% endif %}
),
intermediate_events AS (
    SELECT 
        e.event_id,
        e.page_url,
        e.event_type,
        e.user_id,
        COALESCE(p.product_id, 'Not applicable') AS product_id,
        e.session_id,
        e.created_at,
        COALESCE(o.order_id, 'Not applicable') AS order_id,
        e.date_load,
        COALESCE(p.product_name, 'No Product Name') AS product_name,
        COALESCE(p.product_price, -1) AS product_price,
        COALESCE(o.order_total, -1) AS order_total,
        COALESCE(o.status, 'No Status') AS status,
        u.first_name,
        u.last_name,
        u.email
    FROM stg_events e
    LEFT JOIN stg_products p ON e.product_id = p.product_id
    LEFT JOIN stg_orders o ON e.order_id = o.order_id
    LEFT JOIN snapshot_users u ON e.user_id = u.user_id
)

SELECT * FROM intermediate_events
