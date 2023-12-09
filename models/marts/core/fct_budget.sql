{{
  config(
    materialized='table',
    unique_key=['budget_id']
  )
}}

WITH check_budget_snapshot AS (
    SELECT * 
    FROM {{ ref('check_budget_snapshot') }}
),

fct_budget as (

    select
        budget_id,
        _row,
        quantity,
        budget_date,
        product_id,
        date_load

    from check_budget_snapshot

)


SELECT * FROM fct_budget