{{
  config(
    materialized='table',
    unique_key=['product_id']
  )
}}
WITH stg_products AS (
    SELECT * 
    FROM {{ ref('stg_products') }}
    ),

dim_products AS (
    SELECT
        product_id,
        product_price,
        product_name,
        inventory,
        date_load
    FROM stg_products
    )

SELECT * FROM dim_products