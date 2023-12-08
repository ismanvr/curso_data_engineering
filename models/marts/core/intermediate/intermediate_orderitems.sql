
WITH stg_order_items AS (
    SELECT * 
    FROM {{ ref('stg_order_items') }}
),

stg_orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),

stg_products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
),

intermediate_order_items AS (
    SELECT
        oi.order_items_id 
        , o.order_id 
        , p.product_id
        , oi.quantity
        , oi.date_load
    FROM stg_order_items oi
    LEFT JOIN stg_orders o ON oi.order_id = o.order_id
    LEFT JOIN stg_products p ON oi.product_id = p.product_id
)

SELECT * FROM intermediate_order_items
