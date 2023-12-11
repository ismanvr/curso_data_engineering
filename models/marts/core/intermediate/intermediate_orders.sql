
{{ config(
    materialized='view',
    unique_key = 'orders_id',
    target_schema='core',
    target_table='intermediate_orders'
) 
}}

WITH stg_orders AS (
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

stg_promos AS (
    SELECT *
    FROM {{ ref('stg_promos') }}
),

stg_addresses AS (
    SELECT *
    FROM {{ ref('stg_addresses') }}
),

intermediate_orders AS (
    SELECT
        o.order_id 
        , u.user_id 
        , o.order_total
        , CASE 
            WHEN p.promo_id IS NULL OR p.promo_id = '' THEN CAST({{ dbt_utils.generate_surrogate_key(['9999']) }} AS VARCHAR(50))
            ELSE p.promo_id 
          END AS promo_id
        , a.address_id
        , o.created_at_utc
        , o.shipping_cost_dollars
        , o.order_cost_dollars
        , CASE 
            WHEN o.tracking_id IS NULL OR o.tracking_id = '' THEN 'No Tracking ID' 
            ELSE o.tracking_id 
          END AS tracking_id
        , o.shipping_service
        , o.estimated_delivery_at_utc
        , o.delivered_at_utc
		, o.days_to_deliver        
        , o.status
        , o.date_load_utc
    FROM stg_orders o
    LEFT JOIN snapshot_users u ON o.user_id = u.user_id
    LEFT JOIN stg_promos p ON o.promo_id = p.promo_id
    LEFT JOIN stg_addresses a ON o.address_id = a.address_id
)

SELECT * FROM intermediate_orders
