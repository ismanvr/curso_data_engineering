{{
  config(
    materialized='table',
    unique_key=['budget_id']
  )
}}

WITH intermediate_budget_products AS (
    SELECT * 
    FROM {{ ref('intermediate_budget_products') }}
),

fct_budget as (

    select
        budget_id,
        _row,
        quantity,
        budget_date,
        product_id,
        date_load

    from intermediate_budget_products

)


SELECT * FROM fct_budget