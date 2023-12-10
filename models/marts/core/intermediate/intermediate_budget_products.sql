WITH check_budget_snapshot AS (
    SELECT * 
    FROM {{ ref('check_budget_snapshot') }}
),

stg_products AS (
    SELECT *
    FROM {{ ref('stg_products') }}
),

intermediate_budget_products AS (
    SELECT
        b.budget_id 
        , CASE 
            WHEN p.product_id IS NULL OR p.product_id = '' THEN 'No Product ID' 
            ELSE p.product_id 
          END AS product_id
        , b._row
        , b.quantity
        , b.budget_date
        , b.date_load
    FROM check_budget_snapshot b
    LEFT JOIN stg_products p ON b.product_id = p.product_id
)

SELECT * FROM intermediate_budget_products
