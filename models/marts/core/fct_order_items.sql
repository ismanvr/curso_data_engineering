{{ config(
  materialized='incremental',
  unique_key='order_items_id'
) }}

WITH intermediate_orderitems AS (
    SELECT * 
    FROM {{ ref('intermediate_orderitems') }}
),

fct_order_items AS (
    SELECT
        order_items_id 
        , order_id 
        , product_id
        , quantity
        , date_load
    FROM intermediate_orderitems
)

SELECT * FROM fct_order_items
