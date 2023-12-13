{% snapshot budget_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='budget_id',
      strategy='timestamp',
      updated_at='date_load',
    )
}}

WITH budget_snapshot AS (
    SELECT * 
    FROM {{ ref('stg_budget') }}
)

select * from budget_snapshot

{% endsnapshot %}