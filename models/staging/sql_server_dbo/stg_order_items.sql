{{ config(
    materialized='incremental',
    unique_key = 'order_items_id',
    target_schema='staging',
    target_table='order_items'
    ) 
}}

WITH src_order_items AS (
    SELECT * FROM {{ source('sql_server_dbo', 'order_items') }}
),

stg_order_items AS (
    SELECT
        CAST({{ dbt_utils.generate_surrogate_key(['order_id','product_id']) }} AS VARCHAR(50)) AS order_items_id,
        CAST({{ dbt_utils.generate_surrogate_key(['order_id']) }} AS VARCHAR(50)) AS order_id,
        CAST({{ dbt_utils.generate_surrogate_key(['product_id']) }} AS VARCHAR(50)) AS product_id,
        CAST(quantity as int) as quantity,
        CAST(_fivetran_deleted as boolean) as _fivetran_deleted,
        CAST(_fivetran_synced as timestamp) as date_load
    FROM src_order_items
)

SELECT * FROM stg_order_items

