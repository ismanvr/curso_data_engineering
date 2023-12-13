{{ config(
    materialized='table',
    unique_key = 'promo_id',
    target_schema='core'
) 
}}

WITH
intermediate_orders AS (
    SELECT * 
    FROM {{ ref('intermediate_orders') }}
),

promo_sales AS (
    SELECT
        promo_id
        , COUNT(DISTINCT order_id) as num_orders
        , SUM(order_total) as total_sales_dollars
        , AVG(order_total) as avg_order_value_dollars
        , SUM(shipping_cost_dollars) as total_shipping_cost_dollars
        , AVG(shipping_cost_dollars) as avg_shipping_cost_dollars
    FROM intermediate_orders
    WHERE promo_id != CAST({{ dbt_utils.generate_surrogate_key(['9999']) }} AS VARCHAR(50))
    GROUP BY promo_id
)

SELECT
    p.promo_id
    , p.des_promo
    , ps.num_orders
    , ps.total_sales_dollars
    , ps.avg_order_value_dollars
    , ps.total_shipping_cost_dollars
    , ps.avg_shipping_cost_dollars
FROM {{ ref('stg_promos') }} p
JOIN promo_sales ps ON p.promo_id = ps.promo_id
