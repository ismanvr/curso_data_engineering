{{ config(
    materialized='view',
    target_schema='core',
    target_table='intermediate_suppliers_products'
) 
}}
WITH check_suppliers_snapshot AS (
    SELECT * 
    FROM {{ ref('check_suppliers_snapshot') }}
),

stg_products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
),

intermediate_suppliers_products AS (
    SELECT
        s.suppliers_id 
        , s.product_id
        , s.suppliers_name
        , s.suppliers_email
        , s.suppliers_phone_number
        , p.product_name
        , s.suppliers_product_price_dollars
        , p.product_price
    FROM check_suppliers_snapshot s
    LEFT JOIN stg_products p ON s.product_id = p.product_id
)

SELECT * FROM intermediate_suppliers_products
LIMIT 30
