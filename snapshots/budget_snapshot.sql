{% snapshot budget_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='_row',
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