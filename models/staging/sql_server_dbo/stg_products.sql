with 

src_products as (

    select * from {{ source('sql_server_dbo', 'products') }}

),

stg_products as (

    select
        CAST({{ dbt_utils.generate_surrogate_key(['product_id']) }} AS VARCHAR(50)) AS product_id,
        cast(price as float) as product_price,
        cast(name as varchar(50)) as product_name,
        cast(inventory as int) as inventory,
        _fivetran_deleted,
        cast(_fivetran_synced as timestamp_ntz) as date_load

    from src_products

)

select * from stg_products

UNION ALL
select {{ dbt_utils.generate_surrogate_key('9999') }},0,'no product',0,null,current_timestamp()
-- esto último sirve para representar los casos que involucran columnas vacías en la consulta, mejorando así la integridad

