{{ config(
    materialized='incremental',
    unique_key = 'order_items_id',
    target_schema='staging',
    target_table='order_items'
    ) 
    }}

WITH stg_order_items AS (
    SELECT * FROM {{ source('sql_server_dbo', 'order_items') }}

),
renamed_cast AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id','product_id']) }} AS order_items_id, --uso una clave compuesta porque la clave primaria consta de 2 columnas
        cast(order_id as varchar(50)) as order_id,
        cast(product_id as varchar (50)) as product_id,
        cast(quantity as int) as quantity,
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM stg_order_items
)
SELECT * FROM renamed_cast
