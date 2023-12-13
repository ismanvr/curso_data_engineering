{% snapshot check_suppliers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='suppliers_id',
      strategy='check',
      check_cols=['suppliers_product_price_dollars','suppliers_email','suppliers_phone_number'],
        )
}}

WITH check_suppliers_snapshot AS (
    SELECT * 
    FROM {{ ref('stg_suppliers') }}
)

select * from check_suppliers_snapshot


{% endsnapshot %}