--esto no sería una fact table, sino una dimensión debido a que order_items refleja mejor la max granularidad
WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_orders') }}
),

stg_users AS (
    SELECT *
    FROM {{ ref('stg_users') }}
),

stg_promos AS (
    SELECT *
    FROM {{ ref('stg_promos') }}
),

stg_addresses AS (
    SELECT *
    FROM {{ ref('stg_addresses') }}
),

dim_orders AS (
    SELECT
        o.order_id 
        , u.user_id 
        , o.order_total
        , p.promo_id
        , a.address_id
        , o.created_at_utc
        , o.shipping_cost_dollars
        , o.order_cost_dollars
        , o.tracking_id
        , o.shipping_service
        , o.estimated_delivery_at_utc
        , o.delivered_at_utc
		, o.days_to_deliver        
        , o.status
        , o.date_load_utc
    FROM stg_orders o
    LEFT JOIN stg_users u ON o.user_id = u.user_id
    LEFT JOIN stg_promos p ON o.promo_id = p.promo_id
    LEFT JOIN stg_addresses a ON o.address_id = a.address_id
)

SELECT * FROM dim_orders
