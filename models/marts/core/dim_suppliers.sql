{{ config(
    materialized='table',
    target_schema='core',
) 
}}
with

intermediate_suppliers_products as (

    select * from {{ ref('intermediate_suppliers_products') }}

),

dim_suppliers AS (
    SELECT
        suppliers_id,
        product_id,
        suppliers_name,
        suppliers_email,
        suppliers_phone_number,
        product_name,
        suppliers_product_price_dollars
    FROM intermediate_suppliers_products
)

SELECT * FROM dim_suppliers
