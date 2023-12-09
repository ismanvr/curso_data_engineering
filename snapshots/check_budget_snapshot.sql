{% snapshot check_budget_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='budget_id',
      strategy='check',
      check_cols=['quantity'],
        )
}}

WITH check_budget_snapshot AS (
    SELECT * 
    FROM {{ ref('stg_budget') }}
)

select * from check_budget_snapshot


{% endsnapshot %}