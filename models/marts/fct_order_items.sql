{{
  config(
    materialized='table',
    unique_key=['order_items_id']
  )
}}

WITH stg_order_items AS (
    SELECT * 
    FROM {{ ref('stg_order_items') }}
),


fct_order_items AS (
    SELECT
            order_items_id,
            order_id,
            product_id,
            quantity,
            date_load
    FROM stg_order_items
    )

SELECT * FROM fct_order_items