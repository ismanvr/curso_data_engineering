{{ config(
  materialized='table',
  unique_key=['order_items_id']
) }}

WITH intermediate_orderitems AS (
    SELECT * 
    FROM {{ ref('intermediate_orderitems') }}
),

fct_order_items AS (
    SELECT
        i.order_items_id 
        , i.order_id 
        , i.product_id
        , i.quantity
        , i.date_load
    FROM intermediate_orderitems i
)

SELECT * FROM fct_order_items
