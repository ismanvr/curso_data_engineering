
{{ config(
    materialized='view',
    unique_key = 'order_items_id',
    target_schema='core',
    target_table='intermediate_order_items'
) 
}}

WITH stg_order_items AS (
    SELECT * 
    FROM {{ ref('stg_order_items') }}
    {% if is_incremental() %}
    WHERE date_load > (SELECT max(date_load) FROM {{ this }})
    {% endif %}
),

stg_orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
    {% if is_incremental() %}
    WHERE date_load_utc > (SELECT max(date_load_utc) FROM {{ this }})
    {% endif %}
),

stg_products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
),

intermediate_order_items AS (
    SELECT
        oi.order_items_id 
        , o.order_id
        , o.user_id 
        , o.order_total
        , p.product_id
        , oi.quantity
        , oi.date_load
    FROM stg_order_items oi
    LEFT JOIN stg_orders o ON oi.order_id = o.order_id
    LEFT JOIN stg_products p ON oi.product_id = p.product_id
)

SELECT * FROM intermediate_order_items
