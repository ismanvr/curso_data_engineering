{{ config(
    materialized='incremental',    
    unique_key = 'order_items_id',
    target_schema='core'
) 
}}
WITH snapshot_users AS (
    SELECT * 
    FROM {{ ref('snapshot_users') }}
),

intermediate_orderitems AS (
    SELECT * 
    FROM {{ ref('intermediate_orderitems') }}
),

sales_data AS (
    SELECT
        ioi.order_items_id
        , ioi.order_id 
        , ioi.product_id
        , ioi.quantity
        , ioi.date_load
        , u.user_id
        , u.address_id
        , u.first_name
        , u.last_name
        , u.phone_number
    FROM intermediate_orderitems ioi
    LEFT JOIN snapshot_users u ON ioi. user_id = u.user_id
)

SELECT
    user_id
    , COUNT(DISTINCT order_id) as num_orders
    , COUNT(DISTINCT product_id) as num_products
    , SUM(quantity) as total_quantity
FROM sales_data
GROUP BY user_id
