{{ config(
    materialized='table',
    target_schema='core',
    target_table='supplier_performance_analysis'
) 
}}

WITH intermediate_orderitems AS (
    SELECT * 
    FROM {{ ref('intermediate_orderitems') }}
),

intermediate_suppliers_products AS (
    SELECT *
    FROM {{ ref('intermediate_suppliers_products') }}
),


supplier_performance_analysis AS (
    SELECT
        s.suppliers_id,
        s.suppliers_name,
        COUNT(DISTINCT o.order_id) AS number_of_orders,
        SUM(o.quantity) AS total_quantity,
        AVG(s.suppliers_product_price_dollars) AS average_product_price,
        AVG(o.order_total) AS average_order_total,
        AVG(s.product_price - s.suppliers_product_price_dollars) AS average_profit
    FROM intermediate_suppliers_products s
    JOIN intermediate_orderitems o ON s.product_id = o.product_id
    GROUP BY s.suppliers_id, s.suppliers_name
)

SELECT * FROM supplier_performance_analysis
